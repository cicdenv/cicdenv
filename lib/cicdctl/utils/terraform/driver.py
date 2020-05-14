from os import path, getcwd
import json

import hcl

from . import env
from . import backend_config
from ..aws import config_profile

from .component import is_workspaced
from .component import resolve_variable_opts
from .dependencies import get_cascades

from ...commands.types.target import parse_target

commands_no_vars = ['output', 'fmt', 'validate']
commands_with_vars = [
    'plan',
    'show',
    'apply',
    'destroy',
    'refresh',
    'import',
    'taint',
    'untaint',
    'state',
    'console',
]
unlock_script = 'terraform/bin/clear-state-lock.sh'


class TerraformDriver(object):
    def __init__(self, settings, target, flags=[]):
        self.settings = settings
        self.component = target.component
        self.workspace = target.workspace
        self.flags = flags

        # Assume the component's path is under the top-level terraform/ sub-folder
        _component = self.component.rstrip("/").replace(getcwd(), '').replace('/terraform/', '')  # Normalize
        self.component_dir = path.join(getcwd(), 'terraform', _component)
        
        self.environment = env()

        if self.settings.verbose:
            self.environment['TF_LOG'] = 'DEBUG'

        # Set aws credentials profile with env variables
        self.aws_profile = config_profile(self.workspace)
        self.environment['AWS_PROFILE'] = self.aws_profile

        self.runner = self.settings.runner(cwd=self.component_dir, env=self.environment)

    def _state_prep(self, flags=[]):
        # Odd, but you init, then workspace (first time only)
        # otherwise you workspace then init
        terrform_state = path.join(self.component_dir, '.terraform', 'terraform.tfstate')
        first_time = not path.exists(terrform_state)

        # First time (locally) - components must be init'd first before setting the workspace
        if first_time:
            self.runner.exec(['terraform', 'init'] + list(flags) + ['-upgrade', f'-backend-config={backend_config}'], check=False)

        # If applicable: create workspace where neded before selecting it
        if is_workspaced(self.component_dir):
                workspaces = self.runner.output_list(['terraform', 'workspace', 'list'])
                if not f'* {self.workspace}' in workspaces:
                    if not self.workspace in workspaces:
                        self.runner.exec(['terraform', 'workspace', 'new', self.workspace])
                    else:
                        self.runner.exec(['terraform', 'workspace', 'select', self.workspace])
        
        # Safe to init here for non-first time workspaced states
        if not first_time:
            self.runner.exec(['terraform', 'init'] + list(flags) + ['-upgrade', f'-backend-config={backend_config}'])

    def init(self):
        # "state prep" will handle this completely
        self._state_prep(self.flags)

    def unlock(self):
        self.runner.exec([unlock_script, f'{self.component}:{self.workspace}'], cwd=getcwd())

    def outputs(self, format=None):
        self._state_prep()  # "state prep" the state first, then proceed
        if format == 'json':
            json_stdout = self.runner.output_string(['terraform', 'output', '-json'])
            return json.loads(json_stdout)
        else:  # Default to HCL output (terraform output default)
            hcl_stdout = self.runner.output_string(['terraform', 'output'])
            return hcl.loads(hcl_stdout)

    def output_value(self, key):
        return self.outputs()[key]['value']

    def _run_command_without_vars(self, command):
        self._state_prep()  # "state prep" the state first, then proceed
        self.runner.exec(['terraform', command] + list(self.flags))
        self._run_cascades(command)

    def _run_command_with_vars(self, command):
        self._state_prep()  # "state prep" the state first, then proceed
        var_opts = resolve_variable_opts(self.component_dir, self.aws_profile)
        self.runner.exec(['terraform', command] + var_opts + list(self.flags))
        self._run_cascades(command)

    def _run_cascades(self, command):
        # Handle cascades
        for cascade in get_cascades(self.component):
            if command in cascade['ops']:
                _command = cascade['type']
                target = parse_target(cascade['target'])
                flags = [cascade['opts']]
                driver = TerraformDriver(self.settings, target, flags)
                driver.getattr(_command)()

    def __getattr__(self, name):
        if name in commands_no_vars:
            def _func():
                self._run_command_without_vars(name)
            return _func
        if name in commands_with_vars:
            def _func():
                self._run_command_with_vars(name)
            return _func
