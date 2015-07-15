FROM centos:centos7

MAINTAINER Tomohisa Kusano <siomiz@gmail.com>

# Install packages then remove cache package list information
RUN yum -y update \
  && yum -y groupinstall "Development Tools" \
  && yum -y install readline-devel ncurses-devel openssl-devel openssh-server

COPY build.sh /build.sh
COPY run.c /usr/local/src/
RUN bash /build.sh \
    && rm /build.sh



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

WORKDIR /opt

ENTRYPOINT ["/entrypoint.sh"]

# Note that EXPOSE only works for inter-container links. It doesn't make ports accessible from the host. To expose port(s) to the host, at runtime, use the -p flag.
EXPOSE 500/udp 4500/udp 1701/tcp 22

CMD ["/usr/local/sbin/run"]
