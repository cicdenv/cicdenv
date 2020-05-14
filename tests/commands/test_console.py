from click.testing import CliRunner
from cicdctl import cli


def test_command(runner):
    result = runner.invoke(cli, ['--dry-run', 'console'])
    assert result.exit_code == 0
    assert 'bash' == result.output.strip()
