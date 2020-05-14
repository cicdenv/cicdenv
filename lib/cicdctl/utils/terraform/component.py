from os import path
import subprocess

from ..aws import DEFAULT_REGION
from . import backend_config
from . import parse_variable_comments_tf, parse_tfvars


def is_workspaced(component_dir):
    # Sniff the backend.tf to determine if target is a workspaced state
    with open(path.join(component_dir, 'backend.tf'), 'r') as backend:
        if 'workspace_key_prefix' in backend.read():
            return True
        else:
            return False


def resolve_variable_opts(component_dir, aws_profile):
    # Load variables.tf, locate values from {terraform/*.tfvars, data sources}
    var_opts = []
    vars = parse_variable_comments_tf(path.join(component_dir, 'variables.tf'))  # name -> tfvar {source}
    backend_vars = parse_tfvars(backend_config)
    for name, source in vars.items():
        if source.startswith('dynamodb['):  # DynamoDB item scan: `dynamodb[<table>][<field>]`
            var_opts.append('-var')
            var_opts.append(f'{name}={dynamodb.get_items(source, aws_profile, DEFAULT_REGION)}')
        elif source == 'backend-config.tfvars':  # Backend variables get individual bindings
            var_opts.append('-var')
            var_opts.append(f'{name}={backend_vars[name]}')
        else:  # Other global variables should be single value for file bindings
            var_opts.append('-var-file')
            var_opts.append(path.join(varfile_dir, source))
    return var_opts
