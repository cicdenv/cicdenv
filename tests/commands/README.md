## Purpose
Tests command line parsing thru to what OS commands would be executed.

## Terraform
Tests command line parsing thru to what terraform commands would be executed.

NOTE: `--no-creds`, and `--dry-run` are always used

## Manual Verfication

### Terraform Command
```
cicdctl --no-creds --dry-run terraform init --help test/non-workspaced:dev -no-color
cicdctl --no-creds --dry-run terraform init test/non-workspaced:dev -no-color

cicdctl --no-creds --dry-run terraform fmt test/non-workspaced
cicdctl --no-creds --dry-run terraform fmt test/non-workspaced -check
```

### Cluster Command
```
cicdctl --no-creds --dry-run cluster init 1-18a:dev
cicdctl --no-creds --dry-run cluster init 1-18a:dev node_instance_type:r5dn.4xlarge

cicdctl --no-creds --dry-run cluster create 1-18b:dev
cicdctl --no-creds --dry-run cluster create 1-18b:dev -auto-approve node_instance_type:r5dn.4xlarge
```

### Bastion Command
```
cicdctl --no-creds --dry-run bastion ssh dev
cicdctl --no-creds --dry-run bastion ssh dev --user=fred

cicdctl --no-creds --dry-run bastion ssh dev --host

cicdctl --no-creds --dry-run bastion ssh dev -L <local-port>:<remote-host>:<remote-port>
cicdctl --no-creds --dry-run bastion ssh dev -R <remote-port>:<local-host>:<local-port>
cicdctl --no-creds --dry-run bastion ssh dev -D <local-host>

cicdctl --no-creds --dry-run bastion ssh dev --jump ubuntu@<remote-host>
```

### Jenkins Command
```
cicdctl --no-creds --dry-run jenkins init dist:dev
cicdctl --no-creds --dry-run jenkins init dist:dev --type=distributed

cicdctl --no-creds --dry-run jenkins create test:dev --type=other
cicdctl --no-creds --dry-run jenkins create test:dev --type=colocated

cicdctl --no-creds --dry-run jenkins start test:dev
cicdctl --no-creds --dry-run jenkins stop test:dev

cicdctl --no-creds --dry-run jenkins deploy test:dev
cicdctl --no-creds --dry-run jenkins deploy test:dev --image-tag custom
```

### New-Component Command
```
cicdctl --dry-run new-component mysql/backend
cicdctl --dry-run new-component --workspaced mysql/shared
```

### Kubectl Command
```
cicdctl --no-creds --dry-run kubectl 1-18:dev
cicdctl --no-creds --dry-run kubectl 1-18:dev get pods -n kube-system
```

### AWS IAM Authenticator Command
```
cicdctl --no-creds --dry-run aws-iam-authenticator token 1-18:dev
```
