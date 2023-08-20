#!/usr/bin/env bash

docker run --rm -it -v "$PWD/certs:/certs" openssl-ca
