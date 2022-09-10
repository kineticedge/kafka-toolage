#!/bin/bash

set -e

declare -a clusters=()

if [ $# -eq 1 -a "$1" == "all" ]; then
  clusters=(noauth ssl sasl oauth)
else

while [ $# -gt 0 ]; do
  case "$1" in
    noauth)
      clusters[${#clusters[@]}]="noauth"
      ;;
    ssl)
      clusters[${#clusters[@]}]="ssl"
      ;;
    sasl)
      clusters[${#clusters[@]}]="sasl"
      ;;
    oauth)
      clusters[${#clusters[@]}]="oauth"
      clusters=(oauth)
      ;;
    *)
     echo "usage: $0 [noauth] [ssl] [sasl] [oauth]"
     exit
     ;;
  esac
  shift
done

fi

if [ ${#clusters} -eq 0 ]; then 
  echo "usage: $0 [all] | [noauth] [ssl] [sasl] [oauth]"
  exit
fi

#
# Make sure the jmx_prometheus_javaagent is downloaded in case it needs to be installed.
#
#
# 0.17.0 doesn't seem to work with Kafka, at least not with the cp images.

JMXAGENT_REPO=https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent
JMXAGENT_VERSION=0.16.1
mkdir -p ./tmp
if [ ! -f "./tmp/jmx_prometheus_javaagent-${JMXAGENT_VERSION}.jar" ]; then
  (cd ./tmp; curl -L -s -O ${JMXAGENT_REPO}/${JMXAGENT_VERSION}/jmx_prometheus_javaagent-${JMXAGENT_VERSION}.jar)
fi

#
# make sure jmx_prometheus_javaagent is installed and start the cluster.
#

for cluster in "${clusters[@]}"; do

  if [ ! -f "./${cluster}/jmx_prometheus/jmx_prometheus_javaagent.jar" ]; then
    cp "./tmp/jmx_prometheus_javaagent-${JMXAGENT_VERSION}.jar" "./${cluster}/jmx_prometheus/jmx_prometheus_javaagent.jar"
  fi

  (cd "$cluster"; docker compose up -d)

done

