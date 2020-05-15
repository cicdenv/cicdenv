from os import path
import json

from . import (env, ssh_cmd, 
    DEFAULT_USER_IDENTITY,
    DEFAULT_HOST_IDENTITY)

# Supported bastion sub-commands
bastion_commands = [
    'ssh',
]


class BastionDriver(object):
    def __init__(self, settings, workspace, user, host, jump, flags=[]):
        self.settings = settings
        self.workspace = workspace
        self.user = user
        self.host = host
        self.jump = jump
        self.flags = flags
        
        self.envVars = env()

        self.runner = self.settings.runner(envVars=self.envVars)

    def _run_bastion(self, command):
        if self.host:  # Accesing bastion host for debugging
            user = 'ubuntu'
            port = 2222
            identity = DEFAULT_HOST_IDENTITY
        else:  # Accessing bastion service - normal case
            user = self.user
            port = 22
            identity = DEFAULT_USER_IDENTITY
        self.runner.run(ssh_cmd(command, user, port, identity, self.jump, self.workspace, self.flags))

    def __getattr__(self, name):
        if name in bastion_commands:
            def _func():
                self._run_bastion(name)
            return _func
