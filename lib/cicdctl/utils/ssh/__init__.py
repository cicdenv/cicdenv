import subprocess
import logging
from os import environ, path, chmod, remove

import re
import json
from base64 import b64decode

import boto3

from ..aws import DEFAULT_REGION, config_profile

AGENT_OUTPUT = re.compile(r'''
SSH_AUTH_SOCK=(?P<socket>[^;]+).*
SSH_AGENT_PID=(?P<pid>\d+)
''', re.MULTILINE | re.DOTALL | re.VERBOSE)


DEFAULT_IDENTITY_PREFIX = 'id-shared-ec2'


def default_ssh_key(workspace, prefix=DEFAULT_IDENTITY_PREFIX):
    return path.expanduser(f'~/.ssh/{prefix}-{workspace}')


def start_agent():
    if environ.get('SSH_AUTH_SOCK') is None:
        p = subprocess.run(['ssh-agent', '-s'], stdout=subprocess.PIPE, universal_newlines=True)
        m = AGENT_OUTPUT.search(p.stdout)
        if m is None:
            raise Exception(f'ssh-agent output was not parsed correctly, output:\n{p.stdout}')
        agent_vars = m.groupdict()
        environ['SSH_AUTH_SOCK'] = agent_vars['socket']
        environ['SSH_AGENT_PID'] = agent_vars['pid']


def add_ssh_key(key, passphrase_script=None):
    start_agent()

    key_file = path.expanduser(key)
    if not path.exists(key_file):
        raise Exception(f'ssh key not found: path={key_file}')

    if passphrase_script:
        env = environ.copy()
        env['DISPLAY'] = ''
        env['SSH_ASKPASS'] = passphrase_script
        p = subprocess.run(['setsid', 'ssh-add', key_file], env=env)
    else:
        p = subprocess.run(['ssh-add', key_file])
    if p.returncode != 0:
        raise Exception(f'Adding ssh key to agent failed: key={key_file}')


def add_ssh_secret(workspace, secretId='shared-ec2-keypair', prefix=DEFAULT_IDENTITY_PREFIX, region=DEFAULT_REGION):
    session = boto3.session.Session(profile_name=config_profile(workspace))
    secrets_manager = session.client('secretsmanager', region_name=region)
    response = secrets_manager.get_secret_value(SecretId=secretId)
    secret = json.loads(response['SecretString'])

    #print(secret)
    ssh_key = default_ssh_key(workspace, prefix)
    ssh_pub = f'{ssh_key}.pub'
    ask_pass_script = path.expanduser(f'~/.ssh/.{prefix}-passphrase-{workspace}.sh')
    with open(ssh_key, 'w') as f:
        f.write(b64decode(secret['private-key']).decode())
    with open(ssh_pub, 'w') as f:
        f.write(b64decode(secret['public-key']).decode())
    with open(ask_pass_script, 'w') as f:
        f.write(f'''\
#! /bin/bash
echo "{secret['passphrase']}"
''')
    chmod(ssh_key, 0o600)
    chmod(ssh_pub, 0o600)
    chmod(ask_pass_script, 0o700)
    
    try:
        add_ssh_key(ssh_key, ask_pass_script)
    finally:
        remove(ask_pass_script)
