FROM ubuntu:18.04

COPY build-ca /
COPY server.conf /
COPY easy-rsa-old-2.3.3.tar.gz /
COPY vars /
COPY build-key-server /
COPY build-key /
COPY pkitool /

ENV KEY_NAME="change me"
ENV KEY_OU="change me"
# If you need these different then add ENV KEY_OU on another line and set this to what you want
ENV KEY_ORG=$KEY_OU
ENV EASY_RSA=/etc/easy-rsa-old-2.3.3/easy-rsa/2.0
ENV PKCS_PATH=/usr/bin/pkcs11-tool

RUN apt update && apt upgrade -y && \
apt install openssl openvpn wget -y && \
tar xvzf easy-rsa-old-2.3.3.tar.gz --skip-old-files && \
cp -vr /easy-rsa-old-2.3.3 /etc/easy-rsa-old-2.3.3 && \
rm /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/build-ca && \
rm /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/vars && \
rm /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/build-key-server && \
rm /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/pkitool && \
rm /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/build-key && \
mv build-key /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/build-key && \
mv pkitool /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/pkitool && \
mv build-key-server /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/build-key-server && \
mv vars /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/vars && \
mv build-ca /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/build-ca && mv server.conf /etc/openvpn/server.conf && \
mv /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/openssl-1.0.0.cnf /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/openssl.cnf && \
cd /etc/easy-rsa-old-2.3.3/easy-rsa/2.0/ && chmod +x vars build-ca clean-all build-key-server pkitool build-key && . ./vars && \
./clean-all && \
./build-ca && \
./build-key-server "$KEY_NAME" && \
./build-dh

WORKDIR /etc/easy-rsa-old-2.3.3/easy-rsa/2.0
EXPOSE 443
ENTRYPOINT ["openvpn"]
CMD ["/etc/openvpn/server.conf"]
