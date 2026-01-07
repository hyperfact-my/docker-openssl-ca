#!/usr/bin/env sh
# usage: HOST=example.com IP=127.0.0.1 ./sign-server.sh

arg_ca=${1:-int-ca}
arg_name=${2:-server}
arg_days=${3:-3650}

# create key
# openssl genrsa -out ${arg_name}.key.pem 4096
openssl ecparam -name prime256v1 -genkey -noout -out ${arg_name}.key.pem

# create csr
openssl req -subj "/CN=${HOST}" -sha256 -new -key ${arg_name}.key.pem -out ${arg_name}.csr

# create extfile
echo subjectAltName = DNS:${HOST},IP:${IP} > server-extfile.cnf
echo extendedKeyUsage = serverAuth >> server-extfile.cnf

# sign
openssl x509 -req -days ${arg_days} -sha256 -in ${arg_name}.csr -CA ${arg_ca}.cert.pem -CAkey ${arg_ca}.key.pem \
    -CAcreateserial -out ${arg_name}.cert.pem -extfile server-extfile.cnf

cat ${arg_name}.cert.pem ${arg_ca}.cert.pem > ${arg_name}-fullchain.crt

# access
chmod -v 0400 ${arg_name}.key.pem
chmod -v 0444 ${arg_name}.cert.pem
chmod -v 0444 ${arg_name}-fullchain.crt

# clean
rm -f server-extfile.cnf ${arg_name}.csr

cp -f /ca/ca.pem ./
