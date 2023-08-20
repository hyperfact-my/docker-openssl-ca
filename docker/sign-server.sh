#!/usr/bin/env sh
# usage: HOST=example.com IP=127.0.0.1 ./sign-server.sh

arg_name=${1:-client}
arg_days=${2:-3650}

# create key
openssl genrsa -out ${arg_name}.key.pem 4096

# create csr
openssl req -subj "/CN=${HOST}" -sha256 -new -key ${arg_name}.key.pem -out ${arg_name}.csr

# create extfile
echo subjectAltName = DNS:${HOST},IP:${IP} > server-extfile.cnf
echo extendedKeyUsage = serverAuth >> server-extfile.cnf

# sign
openssl x509 -req -days 3650 -sha256 -in ${arg_name}.csr -CA /ca/ca.pem -CAkey /ca/ca.key.pem \
    -CAcreateserial -out ${arg_name}.cert.pem -extfile server-extfile.cnf

# access
chmod -v 0400 ${arg_name}.key.pem
chmod -v 0444 ${arg_name}.cert.pem

# clean
rm -f server-extfile.cnf

cp -f /ca/ca.pem ./