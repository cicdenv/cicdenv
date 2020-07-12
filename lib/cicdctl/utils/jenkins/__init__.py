from os import path, environ

from ..runners import EnvironmentContext
from ..aws import DEFAULT_REGION, config_profile
from ..terraform import parse_tfvars, domain_config
from ..aws import iam

from ...commands.types.target import parse_target

new_instance_script  = 'terraform/jenkins/bin/generate-instance.sh'
stop_instance_script = 'terraform/jenkins/instances/bin/stop-instance.sh'
list_ips_script      = 'terraform/jenkins/instances/bin/list-instances.sh'


# Workspaced ingresses
def routing_target(workspace):
    return parse_target(f'jenkins/routing:{workspace}')


def env(name, workspace):
    environment=environ.copy()  # Inherits cicdctl's environment by default

    # Set default aws region
    environment['AWS_DEFAULT_REGION'] = DEFAULT_REGION

    # Set aws credentials profile with env variables
    aws_profile = config_profile(workspace)
    environment['AWS_PROFILE'] = aws_profile

    environment['USER'] = iam.get_username()
    
    environment['INSTANCE'] = name
    environment['WORKSPACE'] = workspace
    
    domain = parse_tfvars(domain_config)['domain']
    environment['DOMAIN'] = domain

    logged_keys = ['AWS_DEFAULT_REGION', 'AWS_PROFILE', 'USER', 'INSTANCE', 'WORKSPACE', 'DOMAIN']
    return EnvironmentContext(environment, logged_keys)
