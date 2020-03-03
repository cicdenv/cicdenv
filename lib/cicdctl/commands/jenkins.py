from sys import stdout, stderr
from os import path, getcwd, environ
import subprocess

from types import SimpleNamespace

from cicdctl.logs import log_cmd_line
from aws.credentials import StsAssumeRoleCredentials
from terraform.files import parse_tfvars, domain_config
from cicdctl.commands.terraform import run_terraform


def run_jenkins(args):
    for _target in args.target:
        instance, workspace = _target.split(':')
        if '--type' in args.overrides:  # hacky jenkins deployment type override
            _type = args.overrides[1]    #   accepts '--type {distirubted|colocated}'
            args.overrides = args.overrides[2:]  # shift off the non-terraform args
        else:
            _type = 'distributed'

        jenkins_state = f'jenkins/instances/{instance}:{workspace}'

        _args = SimpleNamespace()
        _args.target = jenkins_state
        _args.overrides = args.overrides

        # Generate the terraform component folder if needed
        if args.command in ['init-jenkins', 'apply-jenkins']:
            if not path.isdir(path.join(getcwd(), f'terraform/jenkins/instances/{instance}')):
                environment = environ.copy()  # Inherit cicdctl's environment
                gen_cmd = ['terraform/jenkins/bin/generate-instance.sh', instance, _type]
                log_cmd_line(gen_cmd)
                subprocess.run(gen_cmd, env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)

        if args.command == 'init-jenkins':
            _args.command = 'init'
            run_terraform(_args)
        elif args.command == 'apply-jenkins':
            _args.command = 'apply'
            run_terraform(_args)
        elif args.command == 'destroy-jenkins':
            _args.command = 'destroy'
            run_terraform(_args)
        elif args.command == 'start-jenkins':
            # Apply the cluster state to restore the ASG counts
            _args.command = 'apply'
            run_terraform(_args)
        elif args.command == 'stop-jenkins':
            environment = environ.copy()  # Inherit cicdctl's environment
            gen_cmd = ['terraform/jenkins/instances/bin/stop-instance.sh', _target]
            log_cmd_line(gen_cmd)
            subprocess.run(gen_cmd, env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)
