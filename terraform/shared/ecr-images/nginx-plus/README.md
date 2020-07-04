## Purpose
NGINX Plus custom image.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/ecr-images/nginx-plus:main
...
```

## Secrets
```bash
📦 $USER:~/cicdenv$ terraform/shared/ecr-images/nginx-plus/bin/secrets-download.sh
```

## Image Maintenance
```bash
📦 $USER:~/cicdenv$ (cd terraform/shared/ecr-images/nginx-plus/; make build)
📦 $USER:~/cicdenv$ (cd terraform/shared/ecr-images/nginx-plus/; make push)

# Update image_tag value in ./outputs.tf
cicdenv$ cicdctl terraform apply shared/ecr-images/nginx-plus
```

## Links
* https://docs.nginx.com/nginx/releases/
* https://www.nginx.com/blog/deploying-nginx-nginx-plus-docker/
* https://docs.docker.com/develop/develop-images/build_enhancements/#new-docker-build-secret-information
