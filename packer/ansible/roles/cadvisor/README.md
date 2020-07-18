## Purpose
This cAdvisor ansible role installs cAdvisor as a systemd service
in the base AMI but does not run enable/start it.

## Usage
From cloud-init (EC2 user-data):
```bash
systemctl daemon-reload
systemctl enable cadvisor
systemctl start cadvisor
```

## Testing
test-vpc:
```bash
# Bring up test-vpc
cicdenv$ cicdctl terraform apply test-vpc:main

# Launch a test instance
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/launch-instances.sh main i3en.large
ssh -i ~/.ssh/manual-testing.pem -o IdentitiesOnly=yes ubuntu@52.32.128.106

# SSH session with tunneling
ssh -i ~/.ssh/manual-testing.pem -o IdentitiesOnly=yes -4 -L localhost:8080:localhost:3546 ubuntu@52.32.128.106

# Access over tunnel
http://localhost:8080/containers/
```

## Images
`gcr.io/google-containers/cadvisor`:
* https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/cadvisor

## Links
* https://github.com/google/cadvisor
  * https://github.com/google/cadvisor/releases
