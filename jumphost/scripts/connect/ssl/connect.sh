#!/bin/bash

unset KAFKA_OPTS

if ! [ -x "$(command -v jq)" ]; then
  echo "installing jq (only needs to be done once after jumphost has been created)."
  mkdir -p /home/appuser/bin
  curl -s -L -o /home/appuser/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  echo ""
  if ! echo "1fffde9f3c7944f063265e9a5e67ae4f  /home/appuser/bin/jq" | md5sum --check --status; then
    echo "checksum failure on jq download and install."
    mv /home/appuser/bin/jq /home/appuser/bin/jq.download_issue
    exit
  fi
  chmod +x /home/appuser/bin/jq
  echo "jq installed (checked with md5sum)."
fi

CURL="curl -s -k -H Content-Type:application/json -H Accept:application/json -u sr:sr-secret"
HOST=https://ssl-connect:8083

$CURL -X DELETE $HOST/connectors/datagen-pageviews | jq
$CURL -X POST   --data @./datagen-pageviews.json $HOST/connectors | jq
$CURL -X GET    $HOST/connectors/datagen-pageviews/status | jq

$CURL -X DELETE $HOST/connectors/filesink-pageviews | jq
$CURL -X POST   --data @./filesink-pageviews.json $HOST/connectors | jq
$CURL -X GET  $HOST/connectors/filesink-pageviews/status | jq
