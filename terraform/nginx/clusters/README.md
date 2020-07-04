## Purpose
NGINX Plus service clusters.

Each nginx service "cluster" has is own component.

## Usage
```bash
cicdenv$ cicdctl nginx create <name>:<acct> -auto-approve instance_type=m5dn.4xlarge

cicdenv$ cicdctl nginx create www:dev -auto-approve instance_type=m5dn.2xlarge
```

## Limitations
### Cluster Name Length
NOTE: currently not validated / enforced.

ASG (AutoScaling Group), TG (Target Group) names are limited to 32 characters.
```
0         10        20        30
|123456789|123456789|123456789|123456789
nginx-servers-
```
