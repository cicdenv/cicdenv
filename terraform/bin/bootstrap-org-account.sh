#!/bin/bash

set -eu -o pipefail

# Set working directory to the project root folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

workspace=${1?Usage: $0 <workspace>}

# Org Account / OU
bin/cicdctl terraform apply "backend:main"
./terraform/backend/bin/populate-organizational-units.sh

# State Locking
terraform/backend/state-locking/bin/create-resources.sh "${workspace}"
# Succeeds on second attempt, quirk of the state locking table itself
   bin/cicdctl terraform init "backend/state-locking:${workspace}" 2>/dev/null \
|| bin/cicdctl terraform init "backend/state-locking:${workspace}"
terraform/backend/state-locking/bin/import-resources.sh "${workspace}"

# Eliminate default VPCs
terraform/network/default-vpcs/bin/populate-vpcs-vars.sh "${workspace}"
bin/cicdctl terraform init "network/default-vpcs:${workspace}"
terraform/network/default-vpcs/bin/import-resources.sh "${workspace}"
bin/cicdctl terraform destroy "network/default-vpcs:${workspace}" -var-file ${workspace}.tfvars -force

# Import Account
bin/cicdctl terraform init "iam/organization-account:${workspace}"
terraform/iam/organization-account/bin/import-resources.sh "${workspace}"
bin/cicdctl terraform apply "iam/organization-account:${workspace}" -auto-approve
