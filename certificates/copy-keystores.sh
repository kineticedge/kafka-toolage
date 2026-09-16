#!/bin/bash

BASE=$(dirname "$0")
cd ${BASE}
. ./env.sh

cp ${SECRETS}/kafka.key  ../clusters/noauth/secrets
cp ${SECRETS}/kafka.server.truststore.jks ../clusters/noauth/secrets
cp ${SECRETS}/noauth-*.jks ../clusters/noauth/secrets

cp ${SECRETS}/kafka.key ${SECRETS}/kafka.server.truststore.jks ../clusters/ssl/secrets
cp ${SECRETS}/kafka.server.truststore.jks ../clusters/ssl/secrets
cp ${SECRETS}/ssl-*.jks ../clusters/ssl/secrets

cp ${SECRETS}/kafka.key ${SECRETS}/kafka.server.truststore.jks ../clusters/sasl/secrets
cp ${SECRETS}/kafka.server.truststore.jks ../clusters/sasl/secrets
cp ${SECRETS}/sasl-*.jks ../clusters/sasl/secrets

cp ${SECRETS}/kafka.key ${SECRETS}/kafka.server.truststore.jks ../clusters/oauth/secrets
cp ${SECRETS}/kafka.server.truststore.jks ../clusters/oauth/secrets
cp ${SECRETS}/oauth-*.jks ../clusters/oauth/secrets


cp ${SECRETS}/kafka.key ../jumphost/secrets
cp ${SECRETS}/kafka.client.truststore.jks ../jumphost/secrets
cp ${SECRETS}/jumphost*.jks ../jumphost/secrets
