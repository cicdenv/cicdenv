from click.testing import CliRunner
from cicdctl import cli


def test_command(runner):
    result = runner.invoke(cli, ['--dry-run', 'test'])
    assert result.exit_code == 0
    assert 'python -m pytest' in result.output
