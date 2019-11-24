from sys import stdout, stderr
from os import path, getcwd, environ
import subprocess

from cicdctl.logs import log_cmd_line
from aws.credentials import StsAssumeRoleCredentials
from terraform.files import parse_tfvars, domain_config


def run_kops(args):
    cluster, workspace = args.target.split(':')

    # Refresh main account AWS mfa credentials if needed
    StsAssumeRoleCredentials().refresh_profile(f'admin-{workspace}')

    environment = environ.copy()  # Inherit cicdctl's environment

    environment['KOPS_STATE_S3_ACL'] = 'bucket-owner-full-control'

    # Kube client config
    kubeconfig = None
    if args.admin:
    	kubeconfig = path.join(getcwd(), f'terraform/kops/clusters/{cluster}/cluster/{workspace}/kops-admin.kubeconfig')
    else:
    	kubeconfig = path.join(getcwd(), f'terraform/kops/clusters/{cluster}/cluster/{workspace}/kops-user.kubeconfig')
    environment['KUBECONFIG'] = kubeconfig

    # Set aws credentials profile with env variables
    environment['AWS_PROFILE'] = f'admin-{workspace}'

    domain = parse_tfvars(domain_config)['domain']
    bucket = f'kops.{domain}'

    try:
        cmd = ['kops']
        cmd.extend(args.arguments)
        cmd.extend([f'--name={cluster}-{workspace}.kops.{domain}', f'--state=s3://{bucket}'])
        log_cmd_line(cmd)

        subprocess.run(cmd, env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)
    except subprocess.CalledProcessError as cpe:
        exit(cpe.returncode)
