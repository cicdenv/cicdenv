## Purpose
Kubernetes mutual TLS CSR init-container.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/ecr-images/certificate-init-container:main
...
```

## Image Build
```bash
cicdenv$ (cd terraform/shared/ecr-images/certificate-init-container/; make build)
```

## Update ECR
```bash
📦 $USER:~/cicdenv$ (cd terraform/shared/ecr-images/certificate-init-container/; make push)
```

## Links
* https://github.com/proofpoint/certificate-init-container
  * https://github.com/onedata/certificate-init-container
