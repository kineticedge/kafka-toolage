#!/bin/bash

cd "$(dirname $0)"

mkdir -p tmp/kafka-ui-api

if [ ! -f ./tmp/kafka-ui-api.jar ]; then
  curl -L -o ./tmp/kafka-ui-api.jar https://github.com/provectus/kafka-ui/releases/download/v0.4.0/kafka-ui-api-v0.4.0.jar
fi

cp ./tmp/kafka-ui-api.jar ./tmp/kafka-ui-api.jar.bk

#(cd tmp/kafka-ui-api; jar xfv ../kafka-ui-api.jar)

mkdir -p tmp/kafka-ui-api/BOOT-INF/lib
cp ../../clusters/oauth/oauth-client/build/libs/kafka-auth0-1.0.0-all.jar ./tmp/kafka-ui-api/BOOT-INF/lib

(cd tmp/kafka-ui-api; jar uvf0 ../kafka-ui-api.jar  .)

#(cd tmp/kafka-ui-api; jar cvfm0 ../kafka-ui-api.jar META-INF/MANIFEST.MF  .)
