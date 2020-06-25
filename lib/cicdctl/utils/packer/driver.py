import json

from . import env, packer_dir, packer_template, workspace
from ..terraform.driver import TerraformDriver
from ...commands.types.target import Target

# Supported packer sub-commands
packer_commands = [
    'validate',
    'build',
    'console',
]


class PackerDriver(object):
    def __init__(self, settings, flags=[]):
        self.settings = settings
        self.flags = flags

        self._run = self.settings.runner(cwd=packer_dir, env_ctx=env()).run

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
        ]

    def _run_packer(self, command):
        vars = self._get_variables()
        self._run(['packer', command] + vars + [packer_template])

    def __getattr__(self, name):
        if name in packer_commands:
            def _func():
                self._run_packer(name)
            return _func
