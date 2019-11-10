#!/bin/bash 

set -euo pipefail

# Prints the tool versions
#  NOTE: could be used inside / outside the cicd environment

cat <<EOF
[Tool]                     [Version]
-----------------------------------------
bash                   --> $(echo $BASH_VERSION | sed 's/-.*$//')
python                 --> $(python --version | awk '{print $NF}')
make                   --> $(make --version | head -n 1 | awk '{print $NF}')
terraform              --> $(terraform version | head -n 1 | awk '{print $NF}')
packer                 --> $(packer version | awk '{print $NF}')
kops                   --> $(kops version | awk '{print $2}')
kubectl                --> $(kubectl version --client --short | awk '{print $NF}')
aws-iam-authenticator  --> $(aws-iam-authenticator version | jq -r '.Version')
aws (cli)              --> $(aws --version | awk -F/ '{print $2}' | awk '{print $1}')
EOF
