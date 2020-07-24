import json

from . import env, packer_dir, packer_template, workspace

from ...commands.types.target import Target

from ..terraform.driver import TerraformDriver
from ..terraform.routing import routing_target

# Supported packer sub-commands
packer_commands = [
    'validate',
    'build',
    'console',
]


class PackerDriver(object):
    def __init__(self, settings, fs, flags=[]):
        self.settings = settings
        self.fs = fs
        self.flags = flags

        self._run = self.settings.runner(cwd=packer_dir, env_ctx=env()).run

    def _ensure_routing(self):
        _network_routing = routing_target('main')
        if not TerraformDriver(self.settings, _network_routing).has_resources():
            TerraformDriver(self.settings, _network_routing, ['-auto-approve']).apply()

    def _tf_outputs(self, component, keys):
        target = Target(component, 'main')
        outputs = TerraformDriver(self.settings, target).outputs()
        return [outputs[key]['value'] for key in keys]

    def _get_variables(self):
        (vpc, subnets)     = self._tf_outputs('network/shared',  ('vpc', 'subnets'))
        (key, account_ids) = self._tf_outputs('packer',          ('key', 'allowed_account_ids'))
        return [
            '-var', f'vpc_id={vpc["id"]}',
            '-var', f'subnet_id={list(subnets["public"].values())[0]["id"]}',
            '-var', f'key_id={key["key_id"]}',
            '-var', f'account_ids={json.dumps(account_ids)}',
            '-var', f'ephemeral_fs={self.fs}',
        ]

    def _run_packer(self, command):
        vars = self._get_variables()
        self._ensure_routing()
        self._run(['packer', command] + vars + [packer_template])

    def __getattr__(self, name):
        if name in packer_commands:
            def _func():
                self._run_packer(name)
            return _func
