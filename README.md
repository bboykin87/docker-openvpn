# docker-openvpn
Docker container for running OpenVpn server.  Generates certs and keys.


sudo docker container run -d --restart=always -p 443:443 --privileged --name openvpn bboykin87/docker-openvpn-arm64
