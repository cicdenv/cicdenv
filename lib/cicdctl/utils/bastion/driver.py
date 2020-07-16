from os import path, environ
import json

from . import (env, ssh_cmd, 
    DEFAULT_USER_IDENTITY)
from ..terraform import parse_tfvars, bastion_config

from ..ssh import add_ssh_secret, default_ssh_key

# Supported bastion sub-commands
bastion_commands = [
    'ssh',
]


class BastionDriver(object):
    def __init__(self, settings, workspace, user, host, ip, flags=[]):
        self.settings = settings
        self.workspace = workspace
        self.user = user
        self.host = host
        self.ip = ip
        self.flags = flags

    def _run_bastion(self, command):
        if self.host:  # Accesing bastion host for debugging
            add_ssh_secret(self.workspace)
            user = 'ubuntu'
            port = parse_tfvars(bastion_config)['ssh_host_port']
            identity = default_ssh_key(self.workspace)
        else:  # Accessing bastion service - normal case
            add_ssh_secret(self.workspace)
            user = self.user
            port = parse_tfvars(bastion_config)['ssh_service_port']
            identity = DEFAULT_USER_IDENTITY

        self._run = self.settings.runner(env_ctx=env()).run
        self._run(['ssh-add', '-L'])
        self._run(ssh_cmd(command, user, port, identity, self.ip, self.workspace, self.flags), env=environ.copy())

    def __getattr__(self, name):
        if name in bastion_commands:
            def _func():
                self._run_bastion(name)
            return _func
