
unset KAFKA_OPTS


curl -X POST -H "Authorization:Basic YnJva2VyLWthZmthOmJyb2tlci1rYWZrYQ==" -H "Content-Type:application/x-www-form-urlencoded" --data 'grant_type=client_credentials&scope=broker.kafka' http://hydra:4444/oauth2/token

