#!/bin/bash

#
# Download and install JMX Prometheus Agents
#

JMXAGENT_REPO=https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent

declare -a clusters=(noauth sasl ssl oauth)

mkdir -p ./tmp
(cd ./tmp; curl -L -s -O ${JMXAGENT_REPO}/0.17.0/jmx_prometheus_javaagent-0.17.0.jar)

for cluster in ${clusters[@]}; do
  if [ ! -f ./${cluster}/jmx_prometheus/jmx_prometheus_javaagent.jar ]; then 
    cp ./tmp/jmx_prometheus_javaagent-0.17.0.jar ./${cluster}/jmx_prometheus/jmx_prometheus_javaagent.jar
  fi
done

