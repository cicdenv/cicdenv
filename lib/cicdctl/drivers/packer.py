from sys import exit, stdout, stderr
from os import path, getcwd, environ
import subprocess

import json

from cicdctl.logs import log_cmd_line
from aws.credentials import StsAssumeRoleCredentials


def run_packer(args):
    # Refresh main account AWS mfa credentials if needed
    StsAssumeRoleCredentials().refresh_profile('admin-main')
     
    environment = environ.copy()  # Inherit cicdctl's environment

    # Set aws credentials profile with env variables
    environment['AWS_PROFILE'] = f'admin-main'

    # Use packer/ as the current working directory
    working_dir = path.join(getcwd(), 'packer')

    sub_command = args.packer_command
    try:
        if sub_command == 'version':
            subprocess.run(['packer', sub_command], env=environment, cwd=working_dir, stdout=stdout, stderr=stderr, check=True)
        elif sub_command in ['build', 'validate']:
            # kops/shared: {vpc_id, public_subnet_id}
            state_dir = path.join(getcwd(), 'terraform', 'kops', 'shared')
            json_stdout = subprocess.check_output(['terraform', 'output', '-json'], env=environment, cwd=state_dir).decode('utf-8')
            outputs = json.loads(json_stdout)
            vpc_id = outputs['vpc_id']['value']
            subnet_id = outputs['public_subnet_ids']['value'][0]

            # packer: {key_id, allowed_account_ids}
            state_dir = path.join(getcwd(), 'terraform', 'packer')
            json_stdout = subprocess.check_output(['terraform', 'output', '-json'], env=environment, cwd=state_dir).decode('utf-8')
            outputs = json.loads(json_stdout)
            key_id = outputs['key_id']['value']
            accounts = outputs['allowed_account_ids']['value']

            # s3 apt-repo
            state_dir = path.join(getcwd(), 'terraform', 'shared', 'apt-repo')
            json_stdout = subprocess.check_output(['terraform', 'output', '-json'], env=environment, cwd=state_dir).decode('utf-8')
            outputs = json.loads(json_stdout)
            apt_repo_bucket = outputs['apt_repo_bucket']['value']

            command_line = [ 
                'packer', 
                sub_command, 
                '-var', f'vpc_id={vpc_id}',
                '-var', f'subnet_id={subnet_id}',
                '-var', f'key_id={key_id}',
                '-var', f'accounts={accounts}',
                '-var', f'apt_repo_bucket={apt_repo_bucket}',
                'ubuntu-18-04.json'
            ]
            log_cmd_line(command_line, cwd=working_dir)

            subprocess.run(command_line, env=environment, cwd=working_dir, stdout=stdout, stderr=stderr, check=True)
    except subprocess.CalledProcessError as cpe:
        exit(cpe.returncode)
