#!/bin/bash

set -e

declare -a clusters=()

if [ $# -gt 0  ]; then
  case "$1" in
    all)
      clusters=(noauth ssl sasl oauth)
      ;;
    noauth)
      clusters=(noauth)
      ;;
    ssl)
      clusters=(ssl)
      ;;
    sasl)
      clusters=(sasl)
      ;;
    oauth)
      clusters=(oauth)
      ;;
    *)
     echo "no such cluster"
     exit
     ;;
  esac
else
  echo "usage: $0 [noauth|ssl|sasl|oauth|all]"
  exit
fi

#
#
#

JMXAGENT_REPO=https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent
JMXAGENT_VERSION=0.16.1

mkdir -p ./tmp

if [ ! -f "./tmp/jmx_prometheus_javaagent-${JMXAGENT_VERSION}.jar" ]; then
  (cd ./tmp; curl -L -s -O ${JMXAGENT_REPO}/${JMXAGENT_VERSION}/jmx_prometheus_javaagent-${JMXAGENT_VERSION}.jar)
fi

for cluster in "${clusters[@]}"; do

  if [ ! -f "./${cluster}/jmx_prometheus/jmx_prometheus_javaagent.jar" ]; then
    cp "./tmp/jmx_prometheus_javaagent-${JMXAGENT_VERSION}.jar" "./${cluster}/jmx_prometheus/jmx_prometheus_javaagent.jar"
  fi

  (cd "$cluster"; docker compose up -d)

done

