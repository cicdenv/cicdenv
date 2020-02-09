## Purpose
Resources for testing AMIs.

## Workspaces
This state is per-account.

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy> test-vpc:${WORKSPACE}
...
```

## Scripts
```
# Launch an ec2 instance in the target account
cicdenv$ cicdctl console
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/launch-instances.sh ${WORKSPACE} <instance-type>
```

## NOTES
```
ssh-keygen -f ~/.ssh/manual-testing.pem -y > ~/.ssh/manual-testing.pub
chmod go-rw ~/.ssh/manual-testing.pub
```
