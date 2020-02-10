## Purpose
Looks AWS IAM Unix users.

## Install
Install Howto:
```
# Update the package index:
apt-get update

# Install libnss-iam deb package:
apt-get install libnss-iam
```

## Usage
TODO.

## Build
```bash
# TODO: will revist once libnss-iam has a 0.1 release
cicdenv/terraform/shared/apt-packages/libnss-iam$ make deb

cicdenv$ . bin/activate
📦 $USER:~/cicdenv/terraform/shared/apt-packages/libnss-iam$ make upload
```

## Links
* https://github.com/gfleury/libnss-iam
