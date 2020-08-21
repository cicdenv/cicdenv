from os import path, getcwd, environ

from ....commands.types.target import parse_target

from ...runners import EnvironmentContext
from ...aws import DEFAULT_REGION, config_profile
from ...terraform import parse_tfvars, domain_config

new_cluster_script = 'terraform/kops/bin/generate-cluster-components.sh'
stop_cluster_script = 'terraform/kops/clusters/bin/stop-cluster.sh'
download_ca_script = 'terraform/kops/backend/bin/kops-ca-download.sh'


def cluster_dir(name):
    return path.join(getcwd(), f'terraform/kops/clusters/{name}')


def pki_dir(workspace):
    return path.join(getcwd(), f'terraform/kops/backend/pki/{workspace}')


def kubeconfig(name, workspace, perms):
    return path.join(getcwd(), f'terraform/kops/clusters/{name}/cluster/{workspace}/kops-{perms}.kubeconfig')


def cluster_fqdn(name, workspace):
    domain = parse_tfvars(domain_config)['domain']
    return f'{name}-kops.{workspace}.{domain}'


def state_store():
    domain = parse_tfvars(domain_config)['domain']
    return f'kops-state-{domain.replace(".", "-")}'


ROUTING= 0
CONFIG = 1
CLUSTER = 2
ACCESS = 3


def cluster_targets(name, workspace):
    return [
        parse_target(f'kops/clusters/{name}/kops:{workspace}'),
        parse_target(f'kops/clusters/{name}/cluster/{workspace}:{workspace}'),
        parse_target(f'kops/clusters/{name}/external-access:{workspace}'),
    ]


def env(workspace):
    environment=environ.copy()  # Inherits cicdctl's environment by default
    
    # Set default aws region
    environment['AWS_DEFAULT_REGION'] = DEFAULT_REGION

    # Set aws credentials profile with env variables
    aws_profile = config_profile(workspace)
    environment['AWS_PROFILE'] = aws_profile

    logged_keys = ['AWS_DEFAULT_REGION', 'AWS_PROFILE']
    return EnvironmentContext(environment, logged_keys)
