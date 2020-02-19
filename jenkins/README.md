# Purpose
Docker images for dedicated Jenkins weekly release(s) jdk-11 server, agent(s).

Routine actions are defined as Makefile targets:
* Version updates & plugin version recording
* Plugin/Image builds uploads to AWS

## Usage
```
# terminal #1 Set AWS credentials (last 1 hour)
cicdenv$ cicdctl console
📦 $USER:~/cicdenv$ cicdctl creds aws-mfa main && (cd jenkins; make aws-creds)

# terminal #2
cicdenv/jenkins$ make build-server run-server

# terminal #3
cicdenv/jenkins$ make build-agent run-agent
```

## Updates
### Jenkins
https://jenkins.io/changelog/ (get version, release date)
```
# Edit: vars.make
JENKINS_VERSION=2.220
RELEASE_DATE=2020.02.09

# New images
cicdenv/jenkins$ make checksum builds

# Test
cicdenv/jenkins$ make run-server
cicdenv/jenkins$ make run-agent
```

## Setup
One time setup includes:
- [ ] custom plugins
- [ ] cicdenv ssh key
- [ ] secrets config
- [ ] cli auth
- [ ] Docker Desktop volumes
- [ ] jenkins secrets files

### Custom Plugins
Build forked / non-standard Jenkins plugins:
```
cicdenv/jenkins$ make build-plugins
```

### SSH Key
Obtain the `cicdenv` Github user ssh key:
```
cicdenv/jenkins$ make ssh-key
```

### CLI Authentication
Populate local agent auth file `~/.jenkins-cli.auth`
```
Github: (User) -> Settings -> Developer settings -> Personal access tokens:
jenkins-cli — read:org

=> <user>:<token>
```

### Docker Desktop Volumes
NOTE:
```
Mac   - Populate disk I/O intensive volumes on the Docker Desktop Host VM
Linux - We create similar volumes on the host
```

Create the necessary volumes:
```
cicdenv/jenkins$ make volumes
```

### Secrets Files
Installs:
* `jenkins_home/{secret.key,secret.key.not-so-secret,identity.key.enc}`
* `jenkins_home/secrets/{master.key,org.*,hudson.*,jenkins.*}`
```
cicdenv/jenkins$ make secrets-files
```
