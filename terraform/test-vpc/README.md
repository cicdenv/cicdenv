## Purpose
Common resources for all KOPS clusters in an account.

## Workspaces
This state is per-account.

## Usage
```
terraform-aws-administration$ <init|plan|apply|destroy> networking/test-vpc:${WORKSPACE}
...
```

## Scripts
```
# Launch an ec2 instance in the target account
terraform-aws-administration$ shell networking/test-vpc/scripts/launch-instances.sh ${WORKSPACE} <instance-type>
```

## NOTES
```
ssh-keygen -f ~/.ssh/manual-testing.pem -y > ~/.ssh/manual-testing.pub
chmod go-rw ~/.ssh/manual-testing.pub
```
