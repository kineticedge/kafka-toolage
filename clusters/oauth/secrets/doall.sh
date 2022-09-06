#    1  cd /etc/kafka/secrets/
#    2  ls -al
#    3  cat check.sh
#    4  ./check.sh
#    5  kafka-topics --bootstrap-server oauth-broker-1:9093 --command-config /etc/kafka/secrets/a.config --create --replication-factor 3 --partitions 4 --topic x
#    6  unset KAFKA_OPTS
#    7  kafka-topics --bootstrap-server oauth-broker-1:9093 --command-config /etc/kafka/secrets/a.config --create --replication-factor 3 --partitions 4 --topic x
#    8  ls -al
#    9  cat admin.conf
#   10  kafka-acls --bootstrap-server ${BOOTSTRAP_SERVER} --command-config ${CONFIG_FILE} ${COMMAND} --force --allow-principal User:${USERNAME} --operation All --topic '*' --group '*' --cluster
#   11  kafka-acls --bootstrap-server localhost:9092 --command-config ./admin.conf --add --force --allow-principal User:broker.server --operation All --topic '*' --group '*' --cluster
#   12  kafka-topics --bootstrap-server oauth-broker-1:9093 --command-config /etc/kafka/secrets/a.config --create --replication-factor 3 --partitions 4 --topic x
#   13  ls -al
#   14  cat connect-users
#   15  cat broker_jaas.conf
#

unset KAFKA_OPTS

export KAFKA_LOG4J_ROOT_LOGLEVEL=INFO

kafka-acls --bootstrap-server localhost:9092 --command-config ./admin.conf --add --force --allow-principal User:broker-kafka --operation All --topic '*' --group '*' --cluster
kafka-topics --bootstrap-server oauth-broker-1:9093 --command-config /etc/kafka/secrets/a.config --create --replication-factor 3 --partitions 4 --topic xx
kafka-console-producer  --bootstrap-server oauth-broker-1:9093 --producer.config /etc/kafka/secrets/a.config --topic xx