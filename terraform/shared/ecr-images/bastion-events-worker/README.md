## Purpose
Closes open SSH sessions on a bastion service instance an
IAM user's access is revoked.

Registers with the [terraform/iam/events] `iam-user-updates` SNS topic.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/ecr-images/bastion-sns-subscriber:main
...
```

## Created
```bash
📦 $USER:~/cicdenv/shared/ecr-images/bastion-sns-subscriber$ make
```

## Push Changes
```bash
📦 $USER:~/cicdenv$ (cd terraform/shared/ecr-images/bastion-events-worker; make build push)
```

## Testing from bastion hosts
```bash
# Pull changes
root@bastion-dev:~# docker pull 014719181291.dkr.ecr.us-west-2.amazonaws.com/bastion-events-worker
root@bastion-dev:~# docker tag  014719181291.dkr.ecr.us-west-2.amazonaws.com/bastion-events-worker events-worker
```

## Connect a Session
```bash
cicdenv$ cicdctl bastion ssh dev
...
$USER@bastion-dev-2:~$ 
```

```bash
root@bastion-dev:~# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
260bbdcacfe6        sshd-worker         "/opt/bin/sshd-entry…"   35 seconds ago      Up 34 seconds       22/tcp              silly_wescoff

root@bastion-dev:~# docker exec -it <container-id> bash -c 'ls /home'
$USER
```

## Links
* https://docs.docker.com/engine/api/sdk/examples/
  * https://docker-py.readthedocs.io/en/stable/index.html
