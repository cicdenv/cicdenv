from sys import exit, stdout, stderr
from os import path, getcwd, environ
import subprocess

import getpass

from cicdctl.logs import log_cmd_line
from aws import credentials
from terraform.files import parse_tfvars, domain_config


def _ssh_cmd(user, port, ssh_key, workspace):
    domain = parse_tfvars(domain_config)['domain']
    return [
        'ssh',
        '-o', 'StrictHostKeyChecking=no',
        '-o', 'UserKnownHostsFile=/dev/null',
        '-o', 'IdentitiesOnly=yes',
        '-o', 'LogLevel=ERROR',
        '-o', 'ForwardAgent=true',
        '-o', 'ConnectTimeout=5',
        '-o', 'ServerAliveInterval=60',
        '-o', 'ServerAliveCountMax=120',
        '-A', 
        '-p', port,
        '-i', f'{ssh_key}',
        f'{user}@bastion-{workspace}.kops.{domain}',
    ]


def _scp_cmd(user, port, ssh_key, workspace):
    return [
        'scp',
        '-o', 'StrictHostKeyChecking=no',
        '-o', 'UserKnownHostsFile=/dev/null',
        '-o', 'IdentitiesOnly=yes',
        '-o', 'LogLevel=ERROR',
        '-o', 'ForwardAgent=true',
        '-o', 'ConnectTimeout=5',
        '-o', 'ServerAliveInterval=60',
        '-o', 'ServerAliveCountMax=120',
        '-P', port,
        '-i', f'{ssh_key}',
    ]


def run_bastion(args):
    environment = environ.copy()  # Inherit cicdctl's environment

    working_dir = getcwd()

    sub_command = args.bastion_command
    workspace = args.workspace

    try:
        if sub_command == 'ssh':
            user = getpass.getuser()
            if '--user' in args.overrides:  # hacky username override
                user = args.overrides[1]    #   accepts '--user <username>'
            identity = path.expanduser('~/.ssh/id_rsa')

            ssh_cmd = _ssh_cmd(user, '22', identity, workspace)
            subprocess.run(ssh_cmd, env=environment, cwd=working_dir, stdout=stdout, stderr=stderr, check=True)
        elif sub_command == 'host':
            user = 'ubuntu'
            identity = path.expanduser('~/.ssh/kops_rsa')

            ssh_cmd = _ssh_cmd(user, '2222', identity, workspace)
            subprocess.run(ssh_cmd, env=environment, cwd=working_dir, stdout=stdout, stderr=stderr, check=True)
        elif sub_command == 'scp':
            user = 'ubuntu'
            identity = path.expanduser('~/.ssh/kops_rsa')
            domain = parse_tfvars(domain_config)['domain']
            destination = f'{user}@bastion-{workspace}.kops.{domain}:{args.overrides[-1]}'

            scp_cmd = _scp_cmd(user, '2222', identity, workspace)
            scp_cmd.extend(args.overrides[:-1])
            scp_cmd.append(destination)
            log_cmd_line(' '.join(scp_cmd))
            
            subprocess.run(scp_cmd, env=environment, cwd=working_dir, stdout=stdout, stderr=stderr, check=True)
        elif sub_command == 'tunnel':
            pass  # TODO
    except subprocess.CalledProcessError as cpe:
        exit(cpe.returncode)
