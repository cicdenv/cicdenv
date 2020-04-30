# Jenkins Updates

Check for core / remoting / jetty releases:
* https://github.com/jenkinsci/jenkins/releases
  * https://jenkins.io/changelog/
  * https://jenkins.io/security/advisories/
  * [winstone/jetty-version =%gt; pom.xml/properties/jetty.version](https://github.com/jenkinsci/winstone/blob/master/pom.xml#L22)
* https://github.com/jenkinsci/remoting/releases

Take note of `version` and `release` date.

[vogtech/cicdenv/jenkins](https://github.com/vogtech/cicdenv/blob/master/jenkins/):
```bash
# Update version vars
cicdenv/jenkins$ vim vars.make
JENKINS_VERSION=2.234
RELEASE_DATE=2020-04-27
JETTY_VERSION=9.4.26.v20200117
REMOTING_VERSION=4.3
IMAGE_REVISION=01

# Update checksum
cicdenv/jenkins$ make checksum
cicdenv/jenkins$ git diff
+JENKINS_VERSION=2.234
+RELEASE_DATE=2020-04-27
+JENKINS_SHA=481ecc74bd6e5df1f32fe6acac59b0cf5e49790c3c2c48ee124ce469d133f4c0
+REMOTING_VERSION=4.3

# Create new docker images
cicdenv/jenkins$ make

# Refresh sts jenkins server/agent sessions, regen certs
cicdenv/jenkins$ cicdctl console
📦 $USER:~/cicdenv$ cicdctl creds aws-mfa main && (cd jenkins; make aws-creds)
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
cicdenv/jenkins$ make push

# Release
cicdenv/jenkins$ make update-default-tags
cicdenv$ cicdctl apply shared/ecr-images/jenkins:main
```
