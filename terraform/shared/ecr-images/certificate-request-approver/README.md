## Purpose
Kubernetes mutual TLS CSR auto-approver.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/ecr-images/certificate-request-approver:main
...
```

## Image Build
```bash
cicdenv$ (cd terraform/shared/ecr-images/certificate-request-approver/; make build)
```

## Update ECR
```bash
📦 $USER:~/cicdenv$ (cd terraform/shared/ecr-images/certificate-request-approver/; make push)
```

## Links
* https://github.com/proofpoint/kapprover
