
# Kafka Toolage

* The purpose of this repository is to showcase how to monitor and leverage various open-source technologies to monitor
your Apache Kafka installation.

## The Apache Kafka Clusters

* To correctly demonstrate how to connect various applications to Apache Kafka, it is important to set up Apache Kafka
with the various security scenarios.

* Certificates: brokers will not start, if certificates are not created; be sure to create them as it can be quite 
confusing starting docker compose; especially with the __--wait__ option.

* 4 Clusters

  * Plaintext/SSL no authentication
  
    * This cluster has two listeners, PLAINTEXT on 9092 and SSL on 9093
    * No Authentication
    * Schema Registry has http and https support

  * SASL
  
    * This cluster has two listeners, SASL_PLAINTEXT and SASL_SSL.
    * SASL protocol is PLAIN for PLAINTEXT and SCRAM-512 for SSL. The idea is that SASL_PLAIN is a internal only IP and can be used for inner broker communication and from internal clients.
      SASL_SSL is external only use and by not allowing PLAIN prevents a compromised inner broker or admin credential from being accessed.
    * Client Authentication Required
    * Basic Auth for Schema Registry and Kafka Connect
    
  * SSL

    * This cluster has one listener, SSL.
    * Client Authentication Required
    * Basic Auth for Schema Registry and Kafka Connect

  * OAuth


* No Localhost access

  * With so many hostnames and ports, this setup does not allow for producing and consuming to Kafka from your local machine.

  * It would be easy to add localhost listeners to any of the clusters, just keep in mind, SSL certificates would require a Subject Alternative Name with localhost in them

## Jumphost

* This machine has access to all of the clusters with the needed configurations and certificates to make it easy to run command line operations.

##  SSL Certificates

  * See the `README.md` file within the __certificates__ directory.


## Part 2 : Apache Kafka SSL Clusters
