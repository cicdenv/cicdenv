from os import path, getcwd, environ

from ..aws import DEFAULT_REGION, config_profile

workspace = 'main'

# Use packer/ as the current working directory
packer_dir = path.join(getcwd(), 'packer')

def env(environment=environ.copy()):  # Inherits cicdctl's environment by default
    # Set default aws region
    environment['AWS_DEFAULT_REGION'] = DEFAULT_REGION

    # Set aws credentials profile with env variables
    environment['AWS_PROFILE'] = config_profile(workspace)

    return environment
