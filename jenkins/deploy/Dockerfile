FROM jenkins/jenkins:latest

# metadata
LABEL module.name="jenkins"

USER root

RUN apt-get update && \
    apt-get install -y vim && \
    apt-get install -y jq


VOLUME ["/tmp", "/var/jenkins_home"]

USER jenkins

EXPOSE 8080 50000

