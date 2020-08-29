import json

from . import env, packer_dir, packer_templates, workspace

from ...commands.types.target import Target

from ..terraform.driver import TerraformDriver
from ..terraform.routing import routing_targets

# Supported packer sub-commands
packer_commands = [
    'validate',
    'build',
    'console',
]


class PackerDriver(object):
    def __init__(self, settings, root_fs, ephemeral_fs, builder, flags=[]):
        self.settings = settings
        self.root_fs = root_fs
        self.ephemeral_fs = ephemeral_fs
        self.builder = builder
        self.flags = flags

        self._run = self.settings.runner(cwd=packer_dir, env_ctx=env()).run

    def _ensure_routing(self):
        network_targets = routing_targets('main')
        for network_target in network_targets:
            if not TerraformDriver(self.settings, network_target).has_resources():
                TerraformDriver(self.settings, network_target, ['-auto-approve']).apply()

    def _tf_outputs(self, component, keys):
        target = Target(component, 'main')
        outputs = TerraformDriver(self.settings, target).outputs()
        return [outputs[key]['value'] for key in keys]

    def _get_variables(self):
        (vpc, subnets) = self._tf_outputs('network/shared', ('vpc', 'subnets'))
        (key, account_ids, main_account) = self._tf_outputs('packer', ('key', 'allowed_account_ids', 'main_account'))

        _variables = [
            '-var', f'vpc_id={vpc["id"]}',
            '-var', f'subnet_id={list(subnets["public"].values())[0]["id"]}',
            '-var', f'key_id={key["key_id"]}',
            '-var', f'account_ids={json.dumps(account_ids)}',
            '-var', f'root_fs={self.root_fs}',
        ]
        if self.builder == 'ebs':
            _variables.append('-var')
            _variables.append(f'ephemeral_fs={self.ephemeral_fs}')
            if self.root_fs == 'zfs':
                _variables.append('-var')
                _variables.append(f'source_owner={main_account["id"]}')
        return _variables
            

    def _run_packer(self, command):
        vars = self._get_variables()
        self._ensure_routing()
        self._run(['packer', command] + vars + [packer_templates[self.builder]])

    def __getattr__(self, name):
        if name in packer_commands:
            def _func():
                self._run_packer(name)
            return _func
