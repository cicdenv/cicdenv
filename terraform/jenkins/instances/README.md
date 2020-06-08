## Purpose
Jenkins service instances.

Each Jenkins service "instance" has is own component.

## Usage
```bash
# Colocated "test" instance
cicdenv$ cicdctl jenkins create <name>:dev -auto-approve --type colocated instance_type=m5dn.4xlarge executors=12

# Distributed "dist" instance
cicdenv$ cicdctl jenkins create <name>:dev -auto-approve --type distributed server_instance_type=m5dn.large agent_instance_type=z1d.2xlarge executors=8 
```

## Updates
In place image updates:
```bash
# Latest
cicdenv$ cicdctl jenkins deploy <name>:dev

# Specific image tag
cicdenv$ cicdctl jenkins deploy <name>:dev --image-tag 2.223-2020.03.01-01
```

## Limitations
### Instance Name Length
NOTE: currently not validated / enforced.

ASG (AutoScaling Group), TG (Target Group) names are limited to 32 characters.
```
0         10        20        30
|123456789|123456789|123456789|123456789
jenkins-server-
jenkins-agents-
jenkins-ext-
jenkins-int-
```

## Links
* https://docs.aws.amazon.com/cli/latest/reference/ecr/describe-images.html
