##Setup


####Please Note
The Official SoftEther VPN built on CentOS 7. There is a limitation with Docker and the volume devicemapper which [appears to be fixed](https://github.com/docker/docker/issues/6980) in Docker 1.6.2 but after numerous attempts and configuration tweaks the building the image was not successful. I was able to change the Dockerfile to use **Ubuntu** as the underlaying OS. **Success**

* L2TP/IPSec PSK
* SecureNAT enabled
* Perfect Forward Secrecy (DHE-RSA-AES256-SHA)
* This build pulls from the official SoftEther VPN GitHub repo master, over 300Mb repo


`docker run -d -p 500:500/udp -p 4500:4500/udp -p 1701:1701/tcp htmlgraphic/vpn`

Connectivity tested on Android + iOS, Mac OS X devices. It seems Android devices do not require L2TP server to have port 1701/tcp open.

## Credentials

All optional:

* `-e PSK`: Pre-Shared Key (PSK), if not set: “notasecret” (without quotes) by default.
* `-e USERNAME`: if not set a random username (“user[nnnn]”) is created.
* `-e PASSWORD`: if not set a random weak password is created.

It only creates a single user account with the above credentials in DEFAULT hub. See the docker log for username and password (unless -e PASSWORD is set), which would look like:

```
========================
user6301
2329.2890.3101.2451.9875
========================
```

Dots (.) are part of the password. Password will not be logged if specified via `-e PASSWORD`; use `docker inspect <container_id>` in case you need to see it.

To review the system generated username and password, use `docker logs <container_id>`
