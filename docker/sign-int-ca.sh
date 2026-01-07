#!/usr/bin/env sh
# usage: ./sign-int-ca.sh

arg_name=${1:-int-ca}
arg_days=${2:-1825}

COUNTRY="MY"
STATE="WP KL"
CITY="KL"
ORGANIZATION="Intermediate CA"
ORGANIZATIONAL_UNIT="Intermediate CA - ${arg_name}"
COMMON_NAME="Intermediate CA - ${arg_name}"
EMAIL="${arg_name}@tapgoing.com"

# create key
# openssl genrsa -out ${arg_name}.key.pem 4096
openssl ecparam -name prime256v1 -genkey -noout -out ${arg_name}.key.pem

# create csr
openssl req -sha256 -new -key ${arg_name}.key.pem -out ${arg_name}.csr \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=${ORGANIZATION}/OU=${ORGANIZATIONAL_UNIT}/CN=${COMMON_NAME}/emailAddress=${EMAIL}"

# sign
openssl x509 -req -days ${arg_days} -sha256 -in ${arg_name}.csr -CA /ca/ca.pem -CAkey /ca/ca.key.pem \
    -CAcreateserial -out ${arg_name}.cert.pem -extensions v3_ca

# access
chmod -v 0400 ${arg_name}.key.pem
chmod -v 0444 ${arg_name}.cert.pem

# clean

cp -f /ca/ca.pem ./
