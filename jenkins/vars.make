SHELL=/bin/bash

JENKINS_INSTANCE=local
AWS_REGION=us-west-2

SERVER_IMAGE_NAME=jenkins-server
AGENT_IMAGE_NAME=jenkins-agent

HTTP_PORT=8080
HTTPS_PORT=8443
HTTP2_PORT=9443

DEFAULT_BROWSER=$(shell if uname -s | grep Darwin > /dev/null; then echo open; else echo x-www-browser; fi)

EDIT_IN_PLACE=$(shell if uname -s | grep Darwin > /dev/null; then echo '-i' \'\'; else echo '-i'; fi)

AGENT_NAME=127.0.0.1

UNSECURE_URL=http://localhost:$(HTTP_PORT)
SERVER_URL=https://localhost:$(HTTPS_PORT)
RESOURCE_URL=https://127.0.0.1:$(HTTPS_PORT)
FOOTER_URL=$(shell git config --get remote.origin.url | sed -e 's/git@/https:\/\//' -e 's/github.com:/github.com\//' -e 's/\.git$$/\//')

#
# Jenkins Server .war file / base image docker build settings
#
JENKINS_DOCKER_GITHUB=git@github.com:jenkinsci/docker.git
JENKINS_DOCKER_BRANCH=master
JENKINS_UID=8008
JENKINS_GID=8008
JENKINS_VERSION=2.220
RELEASE_DATE=2020.02.09
JENKINS_SHA=3f580fff6ad9721eb891361fd14b5d7cc061e0f31c3c3f0a84b9758779a803ad
REMOTING_VERSION=4.2

SERVER_VERSION=$(JENKINS_VERSION)-$(RELEASE_DATE)-01
AGENT_VERSION=$(JENKINS_VERSION)-$(RELEASE_DATE)-01

#
# Use: make checksum-jenkins-war
#
JENKINS_WAR_DOWNLOAD_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/$(JENKINS_VERSION)/jenkins-war-$(JENKINS_VERSION).war
SHA256_CMD=$(shell if uname -s | grep Darwin > /dev/null; then echo 'shasum -a 256'; else echo sha256sum; fi)

user_name=$(shell whoami)
group_name=$(shell id -g -n $(user_name))
user_id=$(shell id -u)
group_id=$(shell id -g)
docker_group=$(shell \
if uname -s | grep Darwin > /dev/null; then \
    dscacheutil -q group -a gid $$(stat -f '%g' /var/run/docker.sock) | grep 'name:' | awk -F': ' '{print $$2}'; \
else \
    stat -c '%g' /var/run/docker.sock; \
fi)
docker_gid=$(shell \
if uname -s | grep Darwin > /dev/null; then \
    stat -f '%g' /var/run/docker.sock; \
else \
    stat -c '%g' /var/run/docker.sock; \
fi)

JENKINS_CLI_JAR=$(CURDIR)/target/jenkins-cli.jar
JENKINS_CLI_AUTH=$(HOME)/.jenkins/auth

PLUGIN_BUILD_IMAGE=maven:3.5.3-jdk-8-alpine

_PS1='📦 \[\033[1;36m\]\u@\h:\[\033[1;34m\]\w\[\033[0;35m\]\[\033[1;36m\]$$ \[\033[0m\]'

DOCKER_NETWORK=host

AWS_PROFILE=admin-main

SERVER_IAM_ROLE_ARN=arn:aws:iam::014719181291:role/jenkins-server
AGENT_IAM_ROLE_ARN=arn:aws:iam::014719181291:role/jenkins-agent

GITHUB_SECRET_ARN=arn:aws:secretsmanager:us-west-2:014719181291:secret:jenkins-github-localhost-pMe1ut
AGENT_SECRET_ARN=arn:aws:secretsmanager:us-west-2:014719181291:secret:jenkins-agent-PYFC56
ENV_SECRET_ARN=arn:aws:secretsmanager:us-west-2:014719181291:secret:jenkins-env-l28fUe

GITHUB_ORGANIZATION=cicdenv
GITHUB_AGENT_USER=jenkins-$(GITHUB_ORGANIZATION)
GITHUB_SSHKEY=$(HOME)/.jenkins/jenkins_rsa

AWS_CONFIG_OPTIONS=$(HOME)/.jenkins/aws
TLS_CONFIG=$(HOME)/.jenkins/tls
TRUST_STORE=/var/lib/jenkins/truststore.jks

EXTRA_CLIENT_OPTS=\
-Djavax.net.ssl.trustStore=/var/lib/jenkins/truststore.jks \
-Djavax.net.ssl.trustStorePassword=jenkins

EXTRA_AGENT_OPTS=\
-Djavax.net.ssl.trustStore=/var/lib/jenkins/truststore.jks \
-Djavax.net.ssl.trustStorePassword=jenkins \
-Djava.util.logging.config.file=/var/lib/jenkins/debug-logging.properties
#EXTRA_AGENT_OPTS=\
#'-Xdebug' \
#'-Xrunjdwp:server=y,transport=dt_socket,address=9088,suspend=y' \
#-Djavax.net.ssl.trustStore=/var/lib/jenkins/truststore.jks \
#-Djavax.net.ssl.trustStorePassword=jenkins -p 9088:9088
#-Djava.util.logging.config.file=/var/lib/jenkins/debug-logging.properties
