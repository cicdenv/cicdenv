from os import path, environ

from ..runners import EnvironmentContext
from ..aws import DEFAULT_REGION, config_profile

new_instance_script  = 'terraform/redis/bin/generate-cluster.sh'


def env(name, workspace):
    environment=environ.copy()  # Inherits cicdctl's environment by default

    # Set default aws region
    environment['AWS_DEFAULT_REGION'] = DEFAULT_REGION

    # Set aws credentials profile with env variables
    aws_profile = config_profile(workspace)
    environment['AWS_PROFILE'] = aws_profile

    logged_keys = ['AWS_DEFAULT_REGION', 'AWS_PROFILE']
    return EnvironmentContext(environment, logged_keys)
