from os import path, environ

from ..runners import EnvironmentContext
from ..aws import DEFAULT_REGION, config_profile

new_group_script = 'terraform/mysql/bin/generate-group.sh'
new_instance_script = 'terraform/mysql/bin/generate-instance.sh'

get_tls_script = 'terraform/mysql/groups/tls/bin/mysql-tls-download.sh'

TLS_KEYS_DIR = 'terraform/mysql/groups/tls/keys'


def env(name, workspace):
    environment=environ.copy()  # Inherits cicdctl's environment by default

    # Set default aws region
    environment['AWS_DEFAULT_REGION'] = DEFAULT_REGION

    # Set aws credentials profile with env variables
    aws_profile = config_profile(workspace)
    environment['AWS_PROFILE'] = aws_profile

    logged_keys = ['AWS_DEFAULT_REGION', 'AWS_PROFILE']
    return EnvironmentContext(environment, logged_keys)
