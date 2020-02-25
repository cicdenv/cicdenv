# Jenkins Updates

Check for core / remoting releases:
* https://github.com/jenkinsci/jenkins/releases
  * [winstone/jetty-version =%gt; pom.xml/properties/jetty.version](https://github.com/jenkinsci/winstone/blob/master/pom.xml#L22)
* https://jenkins.io/changelog/
* https://jenkins.io/security/advisories/

Take note of version and release date.

[vogtech/cicdenv/jenkins](https://github.com/vogtech/cicdenv/blob/master/jenkins/):
```bash
# Update version vars
cicdenv/jenkins$ vim vars.make
JENKINS_VERSION=2.220
RELEASE_DATE=2020.02.09
JETTY_VERSION=9.4.26.v20200117
REMOTING_VERSION=4.0

# Update checksum
cicdenv/jenkins$ make checksum
cicdenv/jenkins$ git diff
+JENKINS_VERSION=2.220
+RELEASE_DATE=2020.02.09
+JENKINS_SHA=25e01768f8f7e2d677fdb09591e5c78f1c9b191ec8e5526f0adbed4d1dbc668a

# Create new docker images
cicdenv/jenkins$ make builds

# Sanity check
cicdenv/jenkins$ make 

# ** volumes **
# See section below (Macs only)
cicdenv/jenkins$ make volumes

# Run the new docker images locally
cicdenv/jenkins$ make run-server # first terminal
cicdenv/jenkins$ make run-agent  # second terminal

# Test a build
cicdenv/ Folder item
jenkins-global-library Pipeline Item
https://github.com/cicdenv/jenkins-global-library.git
TestPipelineScript.groovy

# Update Plugin list for this version
cicdenv/jenkins$ make plugin-versions
cicdenv/jenkins$ git status
...plugin-versions/2.194-2019.09.08-01.txt

# Upload to AWS ECR
cicdenv/jenkins$ make push
```

## Docker Volumes (Mac Only)
Note: local Jenkins docker volumes must be purged AND Docker Destop xhyve VM bounced if 'docker for mac' is restarted.
```bash
# jenkins-agent-workspace
# jenkins-server-home

$ for _v in agent-workspace server-home; do
    if docker volume ls | grep "jenkins-${_v}" &>/dev/null; then
        docker volume rm "jenkins-${_v}"
    fi
done
$ test -z "$(docker ps -q 2>/dev/null)" && osascript -e 'quit app "Docker"'
open --background -a Docker &&
  while ! docker system info > /dev/null 2>&1; do sleep 1; done
  
# Or simply
killall Docker && open /Applications/Docker.app
```
