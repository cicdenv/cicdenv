## Jenkins Updates

Check for core / remoting / jetty releases:
* https://github.com/jenkinsci/jenkins/releases
  * https://jenkins.io/changelog/
  * https://jenkins.io/security/advisories/
  * [winstone/jetty-version => pom.xml/properties/jetty.version](https://github.com/jenkinsci/winstone/blob/master/pom.xml#L22)
* https://github.com/jenkinsci/remoting/releases

## Steps
```bash
# Update version vars
cicdenv/jenkins$ vim vars.make
+JENKINS_VERSION=2.248
+RELEASE_DATE=2020-07-21
JETTY_VERSION=9.4.30.v20200611
REMOTING_VERSION=4.5
IMAGE_REVISION=01

# Update checksum
cicdenv/jenkins$ make checksum
cicdenv/jenkins$ git diff
+JENKINS_VERSION=2.248
+RELEASE_DATE=2020-07-21
+JENKINS_SHA=c30dde89abc48a5d05aabdba1259b76979573ec7b146ae8449e84dd44017c182
+REMOTING_VERSION=4.5

# Create new docker images
cicdenv/jenkins$ make

# Refresh sts jenkins server/agent sessions, regen/import certs
cicdenv$ cicdctl creds aws-mfa main
cicdenv$ cicdctl console
📦 $USER:~/cicdenv/jenkins$ make aws-creds
📦 $USER:~/cicdenv/jenkins$ make tls
cicdenv/jenkins$ make import-cert

# Run the new docker images locally
cicdenv/jenkins$ make clean-server run-server # first terminal
cicdenv/jenkins$ make clean-agent run-agent  # second terminal

# Access UI
cicdenv/jenkins$ make ui

# Test a build
cicdenv/ Folder item
jenkins-global-library Pipeline Item
https://github.com/cicdenv/jenkins-global-library.git
TestPipelineScript.groovy

# Update Plugin list for this version
cicdenv/jenkins$ make plugin-versions
cicdenv/jenkins$ git status
...plugin-versions/2.194-2019.09.08-01.txt

# Update exported JCasC config
# NOTE: disconnect the agent first
cicdenv/jenkins$ make export-config
cicdenv/jenkins$ git status
...

# Upload to AWS ECR
📦 $USER:~/cicdenv$ make push

# Release
cicdenv/jenkins$ make update-default-tags
cicdenv$ cicdctl terraform apply shared/ecr-images/jenkins:main
```
