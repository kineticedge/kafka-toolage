#!/bin/bash

unset KAFKA_OPTS

CONTENT_TYPE='-H Content-Type:application/json -H Accept:application/json'
HOST=https://ssl-connect:8083
CRED='-u sr:sr-secret'

curl -k $CONTENT_TYPE $CRED -X DELETE  $HOST/connectors/datagen-pageviews
echo ""
curl -k $CONTENT_TYPE $CRED -X POST --data @./datagen-pageviews.json $HOST/connectors
echo ""
curl -k $CONTENT_TYPE $CRED -X GET  $HOST/connectors/datagen-pageviews/status
echo ""

curl -k $CONTENT_TYPE $CRED -X DELETE  $HOST/connectors/filesink-pageviews
echo ""
curl -k $CONTENT_TYPE $CRED -X POST --data @./filesink-pageviews.json $HOST/connectors
echo ""
curl -k $CONTENT_TYPE $CRED -X GET  $HOST/connectors/filesink-pageviews/status

