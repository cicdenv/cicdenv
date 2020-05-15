from os import getcwd

import pytest
from click.testing import CliRunner
from cicdctl import cli


from cicdctl.commands import commands

packer_outputs = [(command, '') for command in commands('packer')]

@pytest.mark.parametrize('command,output', packer_outputs)
def test_command(runner, command, output):
    result = runner.invoke(cli, ['--dry-run', 'packer', command])
    assert result.exit_code == 0
    assert output in result.output
