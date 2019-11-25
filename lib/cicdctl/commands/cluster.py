from sys import stdout, stderr
from os import path, getcwd, environ
import subprocess

from types import SimpleNamespace

from cicdctl.logs import log_cmd_line
from aws.credentials import StsAssumeRoleCredentials
from terraform.files import parse_tfvars, domain_config
from cicdctl.commands.terraform import run_terraform


def cluster_states(cluster, workspace):
    return [
        f'kops/clusters/{cluster}/cluster-config:{workspace}',
        f'kops/clusters/{cluster}/cluster/{workspace}:{workspace}',
        f'kops/clusters/{cluster}/external-access:{workspace}',
    ]


def run_cluster(args):
    for _target in args.target:
        cluster, workspace = _target.split(':')
        if args.command == 'init-cluster' or args.command == 'apply-cluster':
            if not path.isdir(path.join(getcwd(), f'terraform/kops/clusters/{cluster}')):
                environment = environ.copy()  # Inherit cicdctl's environment
                gen_cmd = ['terraform/kops/bin/generate-cluster-states.sh', cluster]
                log_cmd_line(gen_cmd)
                subprocess.run(gen_cmd, env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)
            # Always apply the cluster-config state
            _args = SimpleNamespace()
            _args.command = 'apply'
            _args.target = [cluster_states(cluster, workspace)[0]]
            _args.overrides = args.overrides
            run_terraform(_args)
            # cluster / external-access states init/apply
            _args = SimpleNamespace()
            _args.command = 'init' if args.command == 'init-cluster' else 'apply'
            _args.target = cluster_states(cluster, workspace)[1:]
            _args.overrides = args.overrides
            run_terraform(_args)
        elif args.command == 'destroy-cluster':
            _args = SimpleNamespace()
            _args.command = 'destroy'
            _args.target = cluster_states(cluster, workspace)[::-1]  # Destroy in reverse order
            _args.overrides = args.overrides
            run_terraform(_args)
        elif args.command == 'validate-cluster':
            # Refresh AWS mfa credentials if needed
            StsAssumeRoleCredentials().refresh_profile(f'admin-{workspace}')
     
            environment = environ.copy()  # Inherit cicdctl's environment

            # Kube client config
            kubeconfig = path.join(getcwd(), f'terraform/kops/clusters/{cluster}/cluster/{workspace}/kops-admin.kubeconfig')
            if not path.isfile(kubeconfig):  # Use admin creds if available
                kubeconfig = path.join(getcwd(), f'terraform/kops/clusters/{cluster}/cluster/{workspace}/kops-user.kubeconfig')
            environment['KUBECONFIG'] = kubeconfig

            # Set aws credentials profile with env variables
            environment['AWS_PROFILE'] = f'admin-{workspace}'

            domain = parse_tfvars(domain_config)['domain']
            bucket = bucket = f'kops.{domain}'

            try:
                cmd = ['kops', 'validate', 'cluster', f'--name={cluster}-{workspace}.kops.{domain}', f'--state=s3://{bucket}']
                log_cmd_line(cmd)
                
                subprocess.run(cmd, env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)
            except subprocess.CalledProcessError as cpe:
                exit(cpe.returncode)
        elif args.command == 'start-cluster':
            # Apply the cluster state to restore the ASG counts
            _args = SimpleNamespace()
            _args.command = 'apply'
            _args.target = [cluster_states(cluster, workspace)[1]]
            _args.overrides = args.overrides
            run_terraform(_args)
        elif args.command == 'stop-cluster':
            environment = environ.copy()  # Inherit cicdctl's environment
            gen_cmd = ['terraform/kops/clusters/bin/stop-cluster.sh', _target]
            log_cmd_line(gen_cmd)
            subprocess.run(gen_cmd, env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)
