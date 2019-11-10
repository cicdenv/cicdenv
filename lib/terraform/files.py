from os import path, getcwd
import re

import hcl

# terraform/ (*.tfvars parent folder)
varfile_dir = path.join(getcwd(), 'terraform')

# s3 backend config
backend_config = path.join(varfile_dir, 'backend-config.tfvars')

# site domain name
domain_config = path.join(varfile_dir, 'domain.tfvars')

# whitelisted network cidrs
whitelisted_networks = path.join(varfile_dir, 'whitelisted-networks.tfvars')

# Example: variable "bucket" {} # backend-config.tfvars
_var_tf_pattern = re.compile(r'variable\s+"(?P<name>[^"]+)"\s+{}?\s+#\s+(?P<file>.+)')


"""
Non-workspaced:
{
  'terraform': {
    'required_version': '>= 0.12.2', 
    'backend': {
      's3': {
        'key': 'state/main/backend/terraform.tfstate'
      }
    }
  }
}

Workspaced:
{
  'terraform': {
    'required_version': '>= 0.12.2', 
    'backend': {
      's3': {
        'key': 'kops-shared/terraform.tfstate', 
        'workspace_key_prefix': 'state'
      }
    }
  }
}
"""
def parse_terraform_tf(terraform_tf):
    with open(terraform_tf, 'r') as f:
        return hcl.load(f)['terraform']


"""
HCL parser drops comments.
We use the comments to locate the file containing the value.

variable "bucket" {} # backend-config.tfvars
"""
def parse_variable_comments_tf(variables_tf):
    variables = {}  # name => file name
    try:
        with open(variables_tf, 'r') as f:
            for line in f:
                line = line.lstrip()
                if line.startswith('#'):
                    continue  # ignore whole line comments

                m = _var_tf_pattern.match(line)
                if m is not None:
                    name = m.group('name')
                    file = m.group('file')
                    variables[name] = file
    except FileNotFoundError:
        pass  # KOPS generated terraform doesn't have a variables.tf file
    return variables


"""
Sample:
{
  'variable': {
    'bucket': {},
    'domain': {},
    'region': {},
    'target_region': {
      'default': 'us-west-2'
    },
    'whitelisted_cidr_blocks': {
      'type': 'list'
    }
  }
}
"""
def parse_variables_tf(variables_tf):
    variables = {}  # name => file name
    try:
        with open(variables_tf, 'r') as f:
            variables = hcl.load(f)['variable']
    except FileNotFoundError:
        pass  # KOPS generated terraform doesn't have a variables.tf file
    return variables


"""
Sample:
{
  'whitelisted_cidr_blocks': [
    '198.27.234.114/32'
  ]
}
"""
def parse_tfvars(tfvars):
    with open(tfvars, 'r') as f:
        return hcl.load(f)
