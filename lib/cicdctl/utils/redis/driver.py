from os import path, getcwd

from . import (env, 
    new_instance_script)

from ..terraform.driver import TerraformDriver
from ..terraform.routing import routing_targets

from ...commands.types.target import parse_target
from ...commands.types.instance import Instance


class RedisDriver(object):
    def __init__(self, settings, instance, flags=[], type=None):
        self.settings = settings
        self.instance = instance
        self.name = instance.name
        self.workspace = instance.workspace
        self.tf_flags = [flag for flag in flags if flag.startswith('-') and flag[1] != '-']
        self.tf_vars = [flag for flag in flags if not flag.startswith('-')]
        self.flags = [flag for flag in flags if flag.startswith('--')]
        self.type = type
        
        self.component = f'redis/clusters/{self.name}'
        self.target_arg = f'{self.component}:{self.workspace}'
        self.target = parse_target(self.target_arg)

        self.env_ctx = env(self.name, self.workspace)

        self.runner = self.settings.runner(env_ctx=self.env_ctx)
        self._run = self.runner.run
        self._output_list = self.runner.output_list

    def _terraform(self, op):
        driver_method = getattr(TerraformDriver(self.settings, self.target, self.tf_flags), op)
        driver_method()

    def _ensure_component(self):
        if not path.isdir(path.join(getcwd(), f'terraform/{self.component}')):
            self._run([new_instance_script, self.name, *self.tf_vars])

    def _ensure_routing(self):
        network_targets = routing_targets(self.workspace)
        for network_target in network_targets:
            if not TerraformDriver(self.settings, network_target).has_resources():
                TerraformDriver(self.settings, network_target, ['-auto-approve']).apply()

    def _tf_outputs(self, component, workspace, keys):
        target = Target(component, workspace)
        return TerraformDriver(self.settings, target).outputs()

    def init(self):
        self._ensure_component()
        self._terraform('init')

    def create(self):
        self._ensure_component()
        self._ensure_routing()
        self._terraform('apply')

    def destroy(self):
        self._terraform('destroy')
