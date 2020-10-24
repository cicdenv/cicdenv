SHELL=/bin/bash

JENKINS_INSTANCE=local

AWS_REGION=us-west-2
AWS_ACCOUNT_NAME=main
AWS_MAIN_ACCOUNT_ID=014719181291

JDK_VERSION=jdk8
#JDK_VERSION=jdk11

SERVER_IMAGE_NAME=jenkins-server
AGENT_IMAGE_NAME=jenkins-agent

HTTP_PORT=8080
HTTPS_PORT=8443
HTTP2_PORT=9443

SERVER_DEBUGGER_PORT=8000
AGENT_DEBUGGER_PORT=9000
CLI_DEBUGGER_PORT=7000

AGENT_NAME=127.0.0.1

RESOURCE_URL=https://127.0.0.1:$(HTTPS_PORT)
FOOTER_URL=$(shell git config --get remote.origin.url | sed -e 's/git@/https:\/\//' -e 's/github.com:/github.com\//' -e 's/\.git$$/\//')

#
# Jenkins Server .war file / base image docker build settings
#
JENKINS_DOCKER_GITHUB=git@github.com:jenkinsci/docker.git
JENKINS_DOCKER_BRANCH=master
JENKINS_UID=8008
JENKINS_GID=8008

JENKINS_VERSION=2.263
RELEASE_DATE=2020-10-20
JENKINS_SHA=4cbae521ed6c1421b30ee2c490466d3f0b67d33525478d67f61f2100900b6a39
JETTY_VERSION=9.4.30.v20200611
REMOTING_VERSION=4.5

# Reset to 01 when changing the Jenkins version
IMAGE_REVISION=01

SERVER_VERSION=$(JENKINS_VERSION)-$(RELEASE_DATE)-$(IMAGE_REVISION)
AGENT_VERSION=$(JENKINS_VERSION)-$(RELEASE_DATE)-$(IMAGE_REVISION)

#
# Use: make checksum-jenkins-war
#
JENKINS_WAR_DOWNLOAD_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/$(JENKINS_VERSION)/jenkins-war-$(JENKINS_VERSION).war

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

DOCKER_NETWORK=jenkins

AWS_PROFILE=admin-main

SERVER_IAM_ROLE_ARN=arn:aws:iam::014719181291:role/jenkins-server
AGENT_IAM_ROLE_ARN=arn:aws:iam::014719181291:role/jenkins-agent

GITHUB_SECRET_ARN=arn:aws:secretsmanager:us-west-2:014719181291:secret:jenkins-github-localhost-pMe1ut
AGENT_SECRET_ARN=arn:aws:secretsmanager:us-west-2:014719181291:secret:jenkins-agent-PYFC56
ENV_SECRET_ARN=arn:aws:secretsmanager:us-west-2:014719181291:secret:jenkins-env-l28fUe

GITHUB_AGENT_USER=jenkins-cicdenv
GITHUB_SSHKEY=$(HOME)/.jenkins/jenkins_rsa

AWS_CONFIG_OPTIONS=$(HOME)/.jenkins/aws
TLS_CONFIG=$(HOME)/.jenkins/tls
TRUST_STORE=/var/lib/jenkins/truststore.jks

HOOK_SCRIPTS=$(CURDIR)/images/server/init-scripts
CASC_CONFIG=$(CURDIR)/images/server/files/jenkins.yaml

EXTRA_SERVER_OPTS=\
-Djavax.net.ssl.trustStore=/var/jenkins_home/tls/truststore.jks \
-Djavax.net.ssl.trustStorePassword=jenkins \
-Djava.util.logging.config.file=/var/jenkins_home/logging.properties

EXTRA_CLIENT_OPTS=\
-Djavax.net.ssl.trustStore=/var/lib/jenkins/truststore.jks \
-Djavax.net.ssl.trustStorePassword=jenkins \
-Djava.util.logging.config.file=/var/lib/jenkins/logging.properties

EXTRA_AGENT_OPTS=\
-Djavax.net.ssl.trustStore=/var/lib/jenkins/truststore.jks \
-Djavax.net.ssl.trustStorePassword=jenkins \
-Djava.util.logging.config.file=/var/lib/jenkins/logging.properties
