#!/bin/bash

unset KAFKA_OPTS

CONTENT_TYPE='-H Content-Type:application/json -H Accept:application/json'

if [ $# -gt 0  ]; then
  case "$1" in
    sasl)
HOST=https://sasl-connect-1:8083
CRED='-u sr:sr-secret'
      ;;
    ssl)
HOST=https://ssl-connect:8083
CRED='-u sr:sr-secret'
      ;;
    noauth-a)
HOST=http://noauth-connect-a:8083
CRED=""
      ;;
    noauth-b)
HOST=http://noauth-connect-a:8083
CRED=""
      ;;
    *)
     echo "no such"
     exit
     ;;
  esac
else
  echo "no such.."
  exit
fi

#curl -k $CONTENT_TYPE $CRED -X DELETE  $HOST/connectors/datagen-pageviews
#echo ""
#echo curl -k $CONTENT_TYPE $CRED -X POST --data @./datagen-pageviews.json $HOST/connectors
#curl -k $CONTENT_TYPE $CRED -X POST --data @./datagen-pageviews.json $HOST/connectors
#echo ""
curl -k $CONTENT_TYPE $CRED -X GET  $HOST/connectors/datagen-pageviews/status
echo ""

#curl -k $CONTENT_TYPE $CRED -X DELETE  $HOST/connectors/filesink-pageviews
#echo ""
#curl -k $CONTENT_TYPE $CRED -X POST --data @./filesink-pageviews.json $HOST/connectors
#echo ""
curl -k $CONTENT_TYPE $CRED -X GET  $HOST/connectors/filesink-pageviews/status

