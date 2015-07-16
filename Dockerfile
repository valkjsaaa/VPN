FROM ubuntu:14.04
MAINTAINER Jason Gegere <jason@htmlgraphic.com>

# Install packages then remove cache package list information
RUN apt-get update && apt-get -yq install build-essential \
	libssl-dev \
	libreadline-dev \
	libncurses5-dev \
	gcc \
	make \
	wget \
	openssh-client \
	openssh-server \
	redsocks \
	iptables \
	vim \
	git

COPY build.sh /build.sh
COPY run.c /usr/local/src/
RUN bash /build.sh \
	&& rm /build.sh

COPY ./app /app

# Setup routes for iptables
RUN chmod 755 /app/iptables
#RUN sudo ./app/iptables

# Overwrite default redsocks default config
COPY ./app/redsocks.conf /etc/redsocks.conf


RUN apt-get -y remove build-essential && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*


# Update OpenSSH config
RUN mkdir /var/run/sshd
RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/" /etc/ssh/sshd_config
RUN sed -i "s/LogLevel INFO/LogLevel VERBOSE/" /etc/ssh/sshd_config

# Adding additional system user
RUN adduser --system htmlgraphic
RUN mkdir -p /home/htmlgraphic/.ssh

# Clearing and setting authorized ssh keys
COPY authorized_keys /home/htmlgraphic/.ssh/authorized_keys

# Updating shell to bash
RUN sed -i s#/home/htmlgraphic:/bin/false#/home/htmlgraphic:/bin/bash# /etc/passwd

# Updatng root user public key
RUN mkdir -p /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


ENV http_proxy=$http_proxy \
	https_proxy=$https_proxy \
	ftp_proxy=$ftp_proxy \
	no_proxy=$no_proxy \
	proxy_port=$proxy_port


WORKDIR /opt

ENTRYPOINT ["/entrypoint.sh"]

# Note that EXPOSE only works for inter-container links. It doesn't make ports accessible from the host. To expose port(s) to the host, at runtime, use the -p flag.
EXPOSE 500/udp 4500/udp 1701/tcp 22

CMD ["/usr/local/sbin/run"]
