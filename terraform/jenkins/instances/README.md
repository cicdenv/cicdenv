## Purpose
Jenkins service instances.

Each Jenkins service "instance" has is own component.

## Usage
```bash
# Colocated "test" instance
cicdenv$ cicdctl apply-jenkins test:dev -auto-approve --type colocated   instance_type:m5dn.m5dn.4xlarge executors:12

# Distributed "dist" instance
cicdenv$ cicdctl apply-jenkins dist:dev -auto-approve --type distributed server_instance_type:m5dn.4xlarge agent_instance_type:z1d.2xlarge executors:8 
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
