import pytest
from click.testing import CliRunner
from cicdctl import cli

from cicdctl.utils.terraform.templates import (
	workspaced_script,
	non_workspaced_script)

new_component_outputs = [
    (['mysql/backend'], non_workspaced_script),
    (['--workspaced', 'mysql/shared'], workspaced_script),
]

@pytest.mark.parametrize('opts,output', new_component_outputs)
def test_command(runner, opts, output):
    result = runner.invoke(cli, ['--dry-run', 'new-component'] + opts)
    assert result.exit_code == 0
    assert output in result.output
