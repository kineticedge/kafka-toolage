#!/bin/sh

# for custom oauth, need to add library. Kafka-UI does not provide any plugin means to add to application (as far as I 
# figured out, so the .jar has to be rebundled to do so.

cp ../../clusters/oauth/oauth-client/build/libs/kafka-auth0-1.0.0-all.jar .
