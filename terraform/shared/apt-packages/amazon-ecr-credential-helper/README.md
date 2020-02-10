## Purpose
A Docker credential helper to automatically manage credentials for Amazon ECR.
Once configured, the Amazon ECR Credential Helper lets you "docker pull" and
"docker push" container images from Amazon ECR without running "docker login".
Amazon ECR is a container registry and requires authentication for pushing and
pulling images.  You can use the AWS CLI or the AWS SDK to obtain a
time-limited authentication token.  This credential helper automatically
manages obtaining and refreshing authentication tokens when using the Docker
CLI.

For more information about Amazon ECR and how to use it, see the documentation
at https://docs.aws.amazon.com/AmazonECR/latest/userguide/.

## Install
Install Howto:
```
# Update the package index:
apt-get update

# Install amazon-ecr-credential-helper deb package:
apt-get install amazon-ecr-credential-helper
```

## Usage
Configuration: `~/.docker/config.json`
```
{
  "credsStore":"ecr-login"
}

Logs: `~/.ecr/log`
```

## Build
```bash
cicdenv/terraform/shared/apt-packages/amazon-ecr-credential-helper$ make deb

cicdenv$ . bin/activate
📦 $USER:~/cicdenv/terraform/shared/apt-packages/amazon-ecr-credential-helper$ make upload
```

## Links
* https://github.com/awslabs/amazon-ecr-credential-helper
* https://ubuntu.pkgs.org/19.04/ubuntu-universe-amd64/amazon-ecr-credential-helper_0.2.0-1_amd64.deb.html
  * http://archive.ubuntu.com/ubuntu/pool/universe/a/amazon-ecr-credential-helper/amazon-ecr-credential-helper_0.2.0-1_amd64.deb
* https://debian.pkgs.org/10/debian-main-amd64/amazon-ecr-credential-helper_0.2.0-1+b10_amd64.deb.html
  * http://ftp.br.debian.org/debian/pool/main/a/amazon-ecr-credential-helper/amazon-ecr-credential-helper_0.2.0-1+b10_amd64.deb
