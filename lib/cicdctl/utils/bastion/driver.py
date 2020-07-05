from os import path
import json

from . import (ssh_cmd, 
    DEFAULT_USER_IDENTITY)
from ..terraform import parse_tfvars, bastion_config

from ..ssh import add_ssh_secret, default_ssh_key

# Supported bastion sub-commands
bastion_commands = [
    'ssh',
]


class BastionDriver(object):
    def __init__(self, settings, workspace, user, host, ip, flags=[]):
        self.workspace = workspace
        self.user = user
        self.host = host
        self.ip = ip
        self.flags = flags

        self._run = settings.runner().run

    def _run_bastion(self, command):
        if self.host:  # Accesing bastion host for debugging
            user = 'ubuntu'
            port = parse_tfvars(bastion_config)['ssh_host_port']
            identity = default_ssh_key(self.workspace)
        else:  # Accessing bastion service - normal case
            add_ssh_secret(self.workspace)
            user = self.user
            port = parse_tfvars(bastion_config)['ssh_service_port']
            identity = DEFAULT_USER_IDENTITY
        self._run(ssh_cmd(command, user, port, identity, self.ip, self.workspace, self.flags))

    def __getattr__(self, name):
        if name in bastion_commands:
            def _func():
                self._run_bastion(name)
            return _func
