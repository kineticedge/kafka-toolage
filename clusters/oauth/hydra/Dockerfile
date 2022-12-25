FROM oryd/hydra:v1.11.7
#FROM oryd/hydra:v2.0.3

ENV     \
        DSN="sqlite:///var/lib/sqlite/db.sqlite?_fk=true" \
        SECRETS_SYSTEM="_poc_password_abc123-_" \
        LOG_LEAK_SENSITIVE_VALUES=true

USER    root

RUN     \
        mkdir -p /data && \
        mkdir -p /var/lib/sqlite && \
        touch /var/lib/sqlite/db.sqlite && \
        chown -R ory /var/lib/sqlite

COPY    ./client-*.json /data/

COPY    ./hydra.yml /etc/config/hydra/hydra.yml

USER    ory

RUN     hydra migrate -c /etc/config/hydra/hydra.yml sql -e --yes

#
# This is not ideal, but the only way to pre-load these users is to start the server and then run the import
#
# Since this is just for R&D and wanting to remove any pre-configuration for you to setup your oauth2 server,
# this is done here. This could easily be removed and done manually (after hydra is started and before the brokers are started)
# 
# the login callback handler is initialize and needs access at the time the brokers start
#

RUN	nohup sh -c "hydra serve -c /etc/config/hydra/hydra.yml all --dangerous-force-http &" && \
	sleep 10 && \
        hydra clients import /data/client-broker.json /data/client-consumer.json /data/client-producer.json --endpoint http://127.0.0.1:4445 && \
	killall hydra

CMD 	["serve", "-c", "/etc/config/hydra/hydra.yml", "all", "--dangerous-force-http"]


