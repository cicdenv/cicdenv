from os import path, getcwd

from . import (env, routing_target as jenkins_routing,
    new_instance_script,
    stop_instance_script,
    list_ips_script) 
from .ansible import ansible_dir, playbook_actions
from ..ssh import add_ssh_secret

from ..terraform.driver import TerraformDriver
from ..terraform.routing import routing_target as network_routing

from ...commands.types.target import parse_target
from ...commands.types.instance import Instance


class JenkinsDriver(object):
    def __init__(self, settings, instance, flags=[], type=None):
        self.settings = settings
        self.instance = instance
        self.name = instance.name
        self.workspace = instance.workspace
        self.tf_flags = [flag for flag in flags if flag.startswith('-') and flag[1] != '-']
        self.tf_vars = [flag for flag in flags if not flag.startswith('-')]
        self.flags = [flag for flag in flags if flag.startswith('--')]
        self.type = type
        
        self.component = f'jenkins/instances/{self.name}'
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
            self._run([new_instance_script, self.name, self.type, *self.tf_vars])

    def _ensure_routing(self):
        routings = [
          network_routing(self.workspace),
          jenkins_routing(self.workspace),
        ]
        for routing in routings:
            if not TerraformDriver(self.settings, routing).has_resources():
                TerraformDriver(self.settings, routing, ['-auto-approve']).apply()

    def _tf_outputs(self, component, workspace, keys):
        target = Target(component, workspace)
        return TerraformDriver(self.settings, target).outputs()

    def init(self):
        self._ensure_component()
        self._ensure_routing()
        self._terraform('init')

    def create(self):
        self._ensure_component()
        self._ensure_routing()
        self._terraform('apply')

    def destroy(self):
        self._terraform('destroy')

    def start(self):
        self._terraform('apply')

    def stop(self):
        self._run([stop_instance_script, str(self.instance)])

    def deploy(self):
        private_ips = self._output_list([list_ips_script, self.target_arg])

        if '--image-tag' in self.flags:  # Specific image requested
            image_tag = self.flags[self.flags.index('--image-tag') + 1]
            server_image_tag = image_tag
            agent_image_tag = image_tag
        else:  # Source default values
            ecr_outputs = self._tf_outputs('shared/ecr-images/jenkins', 'main')
            server_image_tag = ecr_outputs['jenkins_server_image_repo']['value']['latest']
            agent_image_tag = ecr_outputs['jenkins_agent_image_repo']['value']['latest']
        self.type = self._tf_outputs(self.component, self.workspace)['type']
        
        add_ssh_secret(self.workspace)

        for action in playbook_actions(self.type, private_ips, server_image_tag, agent_image_tag):
            playbook = action['playbook']
            inventory_list = ','.join(action['hosts']) + ','
            extra_vars = ' '.join([f'{var}={value}' for var, value in action['vars'].items()]) if 'vars' in action else ''
            
            ansible_cmd = ['ansible-playbook', playbook, '-i', inventory_list, '--extra-vars', extra_vars]
            self._run(ansible_cmd, cwd=ansible_dir)
