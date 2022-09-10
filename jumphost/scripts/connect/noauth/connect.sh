#!/bin/bash

unset KAFKA_OPTS

if ! [ -x "$(command -v jq)" ]; then
  echo "installing jq (only needs to be done once after jumphost has been created)."
  mkdir -p /home/appuser/bin
  curl -s -L -o /home/appuser/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  chmod +x /home/appuser/bin/jq
  echo "jq installed."
  echo ""
fi

CURL="curl -s -k -H Content-Type:application/json -H Accept:application/json"

HOST=http://noauth-connect-a:8083
$CURL -X DELETE $HOST/connectors/datagen-pageviews | jq
$CURL -X DELETE $HOST/connectors/filesink-pageviews | jq
$CURL -X POST   --data @./a-datagen-pageviews.json $HOST/connectors | jq
$CURL -X POST   --data @./a-filesink-pageviews.json $HOST/connectors | jq
$CURL -X GET    $HOST/connectors/datagen-pageviews/status | jq
$CURL -X GET    $HOST/connectors/filesink-pageviews/status | jq

HOST=http://noauth-connect-b:8083
$CURL -X DELETE $HOST/connectors/datagen-pageviews | jq
$CURL -X DELETE $HOST/connectors/filesink-pageviews | jq
$CURL -X POST   --data @./b-datagen-pageviews.json $HOST/connectors | jq
$CURL -X POST   --data @./b-filesink-pageviews.json $HOST/connectors | jq
$CURL -X GET    $HOST/connectors/datagen-pageviews/status | jq
$CURL -X GET    $HOST/connectors/filesink-pageviews/status | jq

