## Purpose
Bastion service worker container image.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/ecr-images/bastion-sshd-worker:main
...
```

## Image Maintenance
```bash
cicdenv/shared/ecr-images/bastion-sshd-worker$ make 
```
