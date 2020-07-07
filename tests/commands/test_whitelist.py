import pytest
from click.testing import CliRunner
from cicdctl import cli


allowed_networks_outputs = [
    ('list', [], ''),
    ('add', ['--cidr', 'my-ip'], ''),
    ('add', ['--cidr', '67.180.81.198/32'], ''),
    ('remove', ['--cidr', 'my-ip'], ''),
    ('remove', ['--cidr', '67.180.81.198/32'], ''),
]

@pytest.mark.parametrize('command,opts,output', allowed_networks_outputs)
def test_command(runner, command, opts, output):
    result = runner.invoke(cli, ['--dry-run', 'allowed-networks', command] + opts)
    assert result.exit_code == 0
    #assert output in result.output
