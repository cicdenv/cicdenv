## Purpose
This Prmometheus node_exporter ansible role installs the a
host agent as a systemd service in the base AMI but does not run enable/start it.

## Usage
From cloud-init (EC2 user-data):
```bash
systemctl daemon-reload
systemctl enable node-exporter
systemctl start node-exporter
```
## Testing
test-vpc:
```bash
# Bring up test-vpc
cicdenv$ cicdctl terraform apply test-vpc:main

# Launch a test instance
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/launch-instances.sh main i3en.large
ssh -i ~/.ssh/manual-testing.pem -o IdentitiesOnly=yes ubuntu@52.26.213.84

# SSH session with tunneling
ssh -i ~/.ssh/manual-testing.pem -o IdentitiesOnly=yes -4 -L localhost:9100:localhost:9100 ubuntu@52.26.213.84

# Access over tunnel
http://localhost:9100/metrics
```

## Images
* https://hub.docker.com/u/prom
  * https://hub.docker.com/r/prom/node-exporter/tags
  * https://github.com/prometheus/node_exporter/blob/master/Dockerfile

## Links
* https://github.com/prometheus/node_exporter/releases
