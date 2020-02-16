SHELL=/bin/bash

JENKINS_INSTANCE=local
AWS_REGION=us-west-2
AWS_PROFILE=main-infra-admin

SERVER_IMAGE_NAME=jenkins-server
AGENT_IMAGE_NAME=jenkins-agent

HTTP_PORT=8080
AGENT_PORT=5000
SSH_PORT=16022

DEFAULT_BROWSER=$(shell if uname -s | grep Darwin > /dev/null; then echo open; else echo x-www-browser; fi)

EDIT_IN_PLACE=$(shell if uname -s | grep Darwin > /dev/null; then echo '-i' \'\'; else echo '-i'; fi)

AGENT_NAME=127.0.0.1
AGENT_AUTH=$(GITHUB_AGENT_USER):$(GITHUB_AGENT_TOKEN)

SERVER_URL=http://localhost:$(HTTP_PORT)
TUNNELING_URL=jenkins-server:$(AGENT_PORT)
FOOTER_URL=$(shell git config --get remote.origin.url | sed -e 's/git@/https:\/\//' -e 's/github.com:/github.com\//' -e 's/\.git$$/\//')
INTERNAL_URL=http://jenkins-server:$(HTTP_PORT)

#
# Jenkins Server .war file / base image docker build settings
#
JENKINS_DOCKER_GITHUB=git@github.com:jenkinsci/docker.git
JENKINS_DOCKER_BRANCH=master
JENKINS_UID=8008
JENKINS_GID=8008
JENKINS_VERSION=2.220
RELEASE_DATE=2020.02.09
JENKINS_SHA=e5095ae6f8ccf7ef4934d7745f2e086a2e9e2a42a0e6777f009d3e54c8404b96
REMOTING_VERSION=4.0

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
JENKINS_CLI_AUTH=~/.jenkins-cli.auth

PLUGIN_BUILD_IMAGE=maven:3.5.3-jdk-8-alpine

_PS1='📦 \[\033[1;36m\]\u@\h:\[\033[1;34m\]\w\[\033[0;35m\]\[\033[1;36m\]$$ \[\033[0m\]'

DOCKER_NETWORK=jenkins
