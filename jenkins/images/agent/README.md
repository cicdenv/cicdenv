## Users
```
ARG user=jenkins
ARG group=jenkins
ARG uid=8008
ARG gid=8008
```

## Paths
```
/usr/share/jenkins

/var/lib/jenkins/jar-cache

/var/lib/jenkins            HOME
/var/lib/jenkins/agent      AGENT_WORKDIR 
/var/lib/jenkins/.jenkins   AGENT_SETTINGS
```

### Files
* /usr/local/bin/jenkins-agent.sh
* /usr/share/jenkins/slave.jar
* /usr/share/jenkins/jenkins-cli.jar

## Links
* https://github.com/jenkinsci/docker-slave/
  * https://github.com/jenkinsci/docker-slave/blob/master/Dockerfile-jdk11
* https://github.com/jenkinsci/docker-jnlp-slave
* https://github.com/jenkinsci/jnlp-agents
