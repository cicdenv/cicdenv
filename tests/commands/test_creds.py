import pytest
from click.testing import CliRunner
from cicdctl import cli


def test_aws_mfa_noargs(runner):
    result = runner.invoke(cli, ['--no-creds', '--dry-run', 'creds', 'aws-mfa'])
    assert result.exit_code == 0
    assert result.output == ''


def test_aws_mfa_single_workspace(runner):
    result = runner.invoke(cli, ['--no-creds', '--dry-run', 'creds', 'aws-mfa', 'dev'])
    assert result.exit_code == 0
    assert result.output == ''


def test_aws_mfa_multple_workspaces(runner):
    result = runner.invoke(cli, ['--no-creds', '--dry-run', 'creds', 'aws-mfa', 'dev', 'test'])
    assert result.exit_code == 0
    assert result.output == ''


def test_mfa_code(runner):
    result = runner.invoke(cli, ['--no-creds', '--dry-run', 'creds', 'mfa-code'])
    assert result.exit_code == 0
    assert result.output == ''
