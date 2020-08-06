from os import path, environ
import json

from . import (env, ssh_cmd, normalize_ip, workspace_from_ip,
    DEFAULT_USER_IDENTITY)
from ..terraform import parse_tfvars, bastion_config

from ..ssh import add_ssh_secret, default_ssh_key

# Supported bastion sub-commands
bastion_commands = [
    'ssh',
]


class BastionDriver(object):
    def __init__(self, settings, user, host, ip, flags=[]):
        self.settings = settings
        self.user = user
        self.host = host
        self.ip = normalize_ip(ip)
        self.workspace = workspace_from_ip(ip)
        self.flags = flags

    def _run_bastion(self, command):
        if self.host:  # Accesing bastion host for debugging
            user = 'ubuntu'
            port = parse_tfvars(bastion_config)['ssh_host_port']
            identity = default_ssh_key('main')
            add_ssh_secret('main')
        else:  # Accessing bastion service - normal case
            user = self.user
            port = parse_tfvars(bastion_config)['ssh_service_port']
            identity = DEFAULT_USER_IDENTITY
            add_ssh_secret(self.workspace)

        self._run = self.settings.runner(env_ctx=env()).run
        self._run(['ssh-add', '-L'])
        self._run(ssh_cmd(command, user, port, identity, self.ip, self.workspace, self.flags), env=environ.copy())

    def __getattr__(self, name):
        if name in bastion_commands:
            def _func():
                self._run_bastion(name)
            return _func
