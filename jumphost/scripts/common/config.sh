
set -e

if [ "$CLUSTER" == "" ]; then
  echo "CLUSTER not defined."
  exit 1
fi

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


CURL="curl -s -k -H Content-Type:application/json -H Accept:application/json"

#
# if protocol is not set by calling script, default it to plaintext
# (ssl cluster does not have a plaintext listener, so it sets protocol to ssl)
#
PROTOCOL=${PROTOCOL:-plaintext}

#
# special first argument "-p|--protocol"
#
if [[ $# -gt 0 ]]; then
  case $1 in
    -p|--protocol)
      PROTOCOL="$2"
      shift
      shift
      ;;
  esac
fi

ZOOKEEPER=$CLUSTER-zookeeper:2181

ADMIN_BOOTSTRAP_SERVER=$CLUSTER-broker-1:9092,$CLUSTER-broker-2:9092,$CLUSTER-broker-3:9092
ADMIN_CONFIG=./config/admin-plaintext.config

if [ "$PROTOCOL" == "plaintext" ]; then

  BOOTSTRAP_SERVER=$CLUSTER-broker-1:9092,$CLUSTER-broker-2:9092,$CLUSTER-broker-3:9092
  PRODUCER_CONFIG=./config/producer-plaintext.config
  CONSUMER_CONFIG=./config/consumer-plaintext.config
  PERF_TOPIC=performance-plaintext

elif [ "$PROTOCOL" == "ssl" ]; then

  BOOTSTRAP_SERVER=$CLUSTER-broker-1:9093,$CLUSTER-broker-2:9093,$CLUSTER-broker-3:9093
  PRODUCER_CONFIG=./config/producer-ssl.config
  CONSUMER_CONFIG=./config/consumer-ssl.config
  PERF_TOPIC=performance-ssl

else

  echo "protocol unknown $PROTOCOL."
  exit 1

fi