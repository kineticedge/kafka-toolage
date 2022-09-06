# WORK IN PROGRESS -- does not have jar ...

FROM 	provectuslabs/kafka-ui:v0.4.0

RUN	mkdir -p /tmp/BOOT-INF/lib

COPY	/kafka-auth0-1.0.0-all.jar /tmp/BOOT-INF/lib/kafka-auth0-1.0.0-all.jar

RUN	(cd /tmp; jar uvfm0 /kafka-ui-api.jar BOOT-INF/lib)

