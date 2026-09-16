#!/bin/bash

set -e

declare -a clusters=()

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

#
# should reconsider, but now since everything is easy to rebuilt, make it easy to shut everything down.
#
if [ ${#clusters} -eq 0 ]; then
  declare -a clusters=(noauth ssl sasl oauth)
fi

for cluster in "${clusters[@]}"; do
  (cd "$cluster"; docker compose down -v)
done
