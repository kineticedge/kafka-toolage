
CLUSTER=ssl
PROTOCOL=ssl
set -e
. /scripts/common/config.sh

#
# There is no plaintext protocol for the ssl cluster, because of authentication.
#
ADMIN_BOOTSTRAP_SERVER=$CLUSTER-broker-1:9093,$CLUSTER-broker-2:9093,$CLUSTER-broker-3:9093
ADMIN_CONFIG=./config/admin-ssl.config

