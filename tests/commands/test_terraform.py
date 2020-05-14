from os import getcwd

import pytest
from click.testing import CliRunner
from cicdctl import cli

from cicdctl.commands import commands
from cicdctl.utils.terraform.driver import unlock_script, commands_no_vars, commands_with_vars

non_workspaced_component='backend'
non_workspaced_target = f'backend:main'
# workspaced_component='domains'
# workspaced_target = f'{workspaced_component}:dev'
component =  non_workspaced_component
target = non_workspaced_target

root_dir = getcwd()

init_command = f'(cd terraform/{component}; terraform init -upgrade -backend-config={root_dir}/terraform/backend-config.tfvars)'
var_opts = '-var region=us-west-2 -var bucket=terraform.cicdenv.com'
output_no_vars = lambda command: '\n'.join([init_command, f'(cd terraform/{component}; terraform {command})'])
output_with_vars = lambda command: '\n'.join([init_command, f'(cd terraform/{component}; terraform {command} {var_opts})'])

terraform_outputs = [(command, target, output_no_vars(command)) for command in commands_no_vars if command not in ['init', 'unlock']]
terraform_outputs.extend([(command, target, output_with_vars(command)) for command in commands_with_vars if command not in ['init', 'unlock']])
terraform_outputs.append(('init', target, init_command))
terraform_outputs.append(('unlock', target, f'{unlock_script} {target}'))


# -- all commands require TARGET argument
@pytest.mark.parametrize('command', commands('terraform'))
def test_command_requires_target(runner, command):
    result = runner.invoke(cli, ['--no-creds', 'terraform', command, ])
    assert result.exit_code == 2
    assert "Error: Missing argument 'TARGET'" in result.output


# -- most commands work with a target, emit init+command
@pytest.mark.parametrize('command,target,output', terraform_outputs)
def test_command_with_target(runner, command, target, output):
    result = runner.invoke(cli, ['--no-creds', '--dry-run', 'terraform', command, target])
    assert result.exit_code == 0
    assert output in result.output
