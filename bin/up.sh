#!/bin/sh

cd $(dirname $(dirname $0))

(cd clusters/noauth; docker compose up -d ) 
(cd clusters/sasl; docker compose up -d ) 
(cd clusters/ssl; docker compose up -d ) 
