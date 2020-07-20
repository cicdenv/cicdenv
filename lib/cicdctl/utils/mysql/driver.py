from os import path, getcwd

from . import (env, 
    new_group_script,
    new_instance_script,
    get_tls_script,
    TLS_KEYS_DIR)

from ..terraform.driver import TerraformDriver
from ..terraform.routing import routing_target

from ...commands.types.target import parse_target
from ...commands.types.instance import Instance

class MySQLDriver(object):
    def __init__(self, settings, group, flags=[], instance="1"):
        self.settings = settings
        self.group = group
        self.name = group.name
        self.workspace = group.workspace
        self.tf_flags = [flag for flag in flags if flag.startswith('-') and flag[1] != '-']
        self.tf_vars = [flag for flag in flags if not flag.startswith('-')]
        self.flags = [flag for flag in flags if flag.startswith('--')]
        self.instance = instance
        
        # MySQL has 3 terrform components
        # 1) group
        # 2) group/tls
        # 3) instance 1
        self.targets = {
            'group': parse_target(f'mysql/groups/{self.name}:{self.workspace}'),
            'group-tls': parse_target(f'mysql/groups/{self.name}/tls:{self.workspace}'),
            'instance': parse_target(f'mysql/groups/{self.name}/{self.instance}:{self.workspace}'),
        }

        self.env_ctx = env(self.name, self.workspace)

        self.runner = self.settings.runner(env_ctx=self.env_ctx)
        self._run = self.runner.run
        self._output_list = self.runner.output_list

    def _terraform(self, target, op):
        driver_method = getattr(TerraformDriver(self.settings, target, self.tf_flags), op)
        driver_method()

    def _ensure_group_components(self):
        if not path.isdir(path.join(getcwd(), self.targets['group'].component)):
            self._run([new_group_script, self.name, *self.tf_vars])
        self._terraform(self.targets['group'], 'apply')
        if not path.isdir(path.join(getcwd(), f'{TLS_KEYS_DIR}/${self.name}/${self.workspace}')):
            self._run([get_tls_script, f'{self.name}:{self.workspace}'])
        self._terraform(self.targets['group-tls'], 'apply')

    def _ensure_instance(self):
        if not path.isdir(path.join(getcwd(), self.targets['instance'].component)):
            self._run([new_instance_script, self.name, self.instance, *self.tf_vars])

    def _ensure_routing(self):
        network_routing = routing_target(self.workspace)
        if not TerraformDriver(self.settings, network_routing).has_resources():
            TerraformDriver(self.settings, network_routing, ['-auto-approve']).apply()

    def init(self):
        self._ensure_group_components()
        self._ensure_instance()
        self._terraform(self.targets['instance'], 'init')

    def create(self):
        self._ensure_group_components()
        self._ensure_instance()
        self._ensure_routing()
        self._terraform(self.targets['instance'], 'apply')

    def destroy(self):
        self._terraform(self.targets['instance'], 'destroy')
        self._terraform(self.targets['group-tls'], 'destroy')
        self._terraform(self.targets['group'], 'destroy')
