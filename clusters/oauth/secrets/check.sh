
unset KAFKA_OPTS

kafka-topics --bootstrap-server oauth-broker-1:9093 --command-config /etc/kafka/secrets/a.config --list

