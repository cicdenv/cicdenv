## Purpose
Per account terraform backend locking.

## Workspaces
This state is per-account.

## Init
```
# Interactive shell
cicdenv$ make

# Create the dynamodb tables manually
${USER}:~/cicdenv$ for acct in main $(grep 'name' terraform/accounts.tfvars | awk -F= '{print $2}' | sed 's/"//g'); do
    terraform/backend/state-locking/bin/create-resources.sh "$acct"
done
${USER}:~/cicdenv$ exit

# Intialize terraform
cicdenv$ for acct in main $(grep 'name' terraform/accounts.tfvars | awk -F= '{print $2}' | sed 's/"//g'); do
    cicdctl init backend/state-locking:${acct}
done

# Interactive shell
cicdenv$ make

# Now import the dynamodb table into terraform
${USER}:~/cicdenv$ for acct in main $(grep 'name' terraform/accounts.tfvars | awk -F= '{print $2}' | sed 's/"//g'); do
    terraform/bin/clear-state-lock.sh "backend/state-locking:${acct}"
    terraform/backend/state-locking/bin/import-resources.sh "$acct"
done
${USER}:~/cicdenv$ exit
```

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy> backend/state-locking:${WORKSPACE}
...
```
