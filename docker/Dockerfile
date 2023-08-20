FROM alpine:latest

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk --no-cache add ca-certificates \
    && apk --no-cache add tzdata \
    && cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata \
    && echo 'alias ll="ls $LS_OPTIONS -l"' >> ~/.rc
RUN apk --no-cache add openssl
ADD aliases.sh /etc/profile.d/aliases.sh

ENV COUNTRY="CN"
ENV STATE="ZJ"
ENV CITY="HZ"
ENV ORGANIZATION="CA"
ENV ORGANIZATIONAL_UNIT="Root CA"
ENV COMMON_NAME="Root CA"
ENV EMAIL="ca@ca.com"

WORKDIR /ca

COPY ./sign-server.sh /usr/local/bin/sign-server
COPY ./sign-client.sh /usr/local/bin/sign-client
RUN openssl genrsa -out ca.key.pem 4096
RUN openssl req -new -x509 -days 3650 -key "ca.key.pem" -sha256 -out "ca.pem" \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=${ORGANIZATION}/OU=${ORGANIZATIONAL_UNIT}/CN=${COMMON_NAME}/emailAddress=${EMAIL}"
RUN chmod -v 0400 ca.key.pem && chmod -v 0444 ca.pem

VOLUME [ "/ca" ]

WORKDIR /certs
VOLUME [ "/certs" ]

LABEL Name=openssl-ca Version=0.0.1
