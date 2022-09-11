
set -e

unset KAFKA_OPTS

if ! [ -x "$(command -v jq)" ]; then
  echo "installing jq (only needs to be done once after jumphost has been created)."
  mkdir -p /home/appuser/bin
  curl -s -L -o /home/appuser/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  chmod +x /home/appuser/bin/jq
  echo "jq installed."
  echo ""
fi
