#!/bin/sh

hydra clients import /data/client-broker.json /data/client-consumer.json /data/client-producer.json --endpoint http://hydra:4445
