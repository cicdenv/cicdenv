from sys import stdout, stderr
from os import path, getcwd, environ
import subprocess
import io

import getpass

from types import SimpleNamespace

from cicdctl.logs import log_cmd_line
from aws.credentials import StsAssumeRoleCredentials
from terraform.files import parse_tfvars, domain_config
from terraform.outputs import get_output
from cicdctl.commands.terraform import run_terraform


def run_jenkins(args):
    for _target in args.target:
        instance, workspace = _target.split(':')
        if '--type' in args.overrides:  # hacky jenkins deployment type override
            _type = args.overrides[1]    #   accepts '--type {distirubted|colocated}'
            args.overrides = args.overrides[2:]  # shift off the non-terraform args

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
            stop_cmd = ['terraform/jenkins/instances/bin/stop-instance.sh', _target]
            log_cmd_line(stop_cmd)
            subprocess.run(stop_cmd, env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)
        elif args.command == 'deploy-jenkins':
            proc = subprocess.Popen(['terraform/jenkins/instances/bin/list-instances.sh', _target], stdout=subprocess.PIPE)
            private_ips = [private_ip.rstrip() for private_ip in io.TextIOWrapper(proc.stdout, encoding="utf-8")]

            environment = environ.copy()  # Inherit cicdctl's environment
            environment['USER'] = getpass.getuser()

            environment['INSTANCE'] = instance
            environment['WORKSPACE'] = workspace

            domain = parse_tfvars(domain_config)['domain']
            environment['DOMAIN'] = domain

            ansible_dir = path.join(getcwd(), 'terraform/jenkins/ansible')
            image_tag = '2.223-2020.03.01-01'

            actions = []
            if _type == 'distributed':
                actions = [
                    {
                        'playbook': 'start.yml',
                        'hosts': [private_ips[0]],
                    },
                    {
                        'playbook': 'server.yml',
                        'hosts': [private_ips[0]],
                        'vars': {
                            'jenkins_server_tag': image_tag,
                            'jenkins_agent_tag': image_tag,
                        }
                    },
                    {
                        'playbook': 'agent.yml',
                        'hosts': private_ips[1:],
                        'vars': {
                            'jenkins_server_tag': image_tag,
                            'jenkins_agent_tag': image_tag,
                        }
                    },
                    {
                        'playbook': 'end.yml',
                        'hosts': [private_ips[0]],
                    },
                ]
            else:  # 'colocated'
                actions = [
                    {
                        'playbook': 'start.yml',
                        'hosts': [private_ips[0]],
                    },
                    {
                        'playbook': 'colocated.yml',
                        'hosts': [private_ips[0]],
                        'vars': {
                            'jenkins_server_tag': image_tag,
                            'jenkins_agent_tag': image_tag,
                        }
                    },
                    {
                        'playbook': 'end.yml',
                        'hosts': [private_ips[0]],
                    },
                ]
            for action in actions:
                playbook = action['playbook']
                inventory_list = ','.join(action['hosts']) + ','
                extra_vars = ' '.join([f'{var}={value}' for var, value in action['vars'].items()]) if 'vars' in action else ''

                ansible_cmd = ['ansible-playbook', playbook, '-i', inventory_list, '--extra-vars', extra_vars]
                log_cmd_line(ansible_cmd)
                subprocess.run(ansible_cmd, env=environment, cwd=ansible_dir, stdout=stdout, stderr=stderr, check=True)
