
unset KAFKA_OPTS


curl -X POST -H "Authorization:Basic YnJva2VyLWthZmthOmJyb2tlci1rYWZrYQ==" -H "Content-Type:application/x-www-form-urlencoded" --data "token=$1" http://hydra:4445/oauth2/introspect

