# Purpose
Docker images for dedicated Jenkins weekly release(s) jdk-11 server, agent(s).

Routine actions are defined as Makefile targets:
* Version updates & plugin version recording
* Plugin/Image builds uploads to AWS

## Updates
See [docs/UPDATES.md]

## Usage
```bash
# terminal #1 Set AWS credentials (last 1 hour)
cicdenv$ cicdctl creds aws-mfa main
cicdenv$ cicdctl console
📦 $USER:~/cicdenv/jenkins$ make aws-creds

# Create/Renew self signed cert
📦 $USER:~/cicdenv/jenkins$ make tls
cicdenv/jenkins$ make import-cert

# terminal #2
cicdenv/jenkins$ make [JDK_VERSION=jdk8|jdk11] build-server run-server

# terminal #3
cicdenv/jenkins$ make [JDK_VERSION=jdk8|jdk11] build-agent run-agent
```

## Setup
One time setup includes:
- [ ] custom plugins
- [ ] cicdenv ssh key
- [ ] cli/agent auth
- [ ] Docker volumes

NOTE: refreshing the assumed server/agent aws sts sessions is required hourly

### Custom Plugins
Build forked / non-standard Jenkins plugins:
```
cicdenv/jenkins$ make build-plugins
```

### SSH Key
Obtain the `cicdenv` Github user ssh key:
```bash
cicdenv/jenkins$ make ssh-key
```

### Agent Authentication
Obtain the cli/agent to server creds
```bash
cicdenv/jenkins$ make agent-auth
```

### Docker Desktop Volumes
NOTE:
```
Mac   - Populate disk I/O intensive volumes on the Docker Desktop Host VM
Linux - We create similar volumes on the host
```

Create the necessary volumes:
```bash
cicdenv/jenkins$ make volumes
```
