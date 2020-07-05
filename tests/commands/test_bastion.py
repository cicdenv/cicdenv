import getpass

import pytest
from click.testing import CliRunner
from cicdctl import cli


from cicdctl.utils.bastion import (ssh_opts, bastion_address,
    DEFAULT_USER_IDENTITY)

user = getpass.getuser()
workspace =  'dev'
address = bastion_address(user, workspace)

ssh_outputs = [
    ([], f'ssh {" ".join(ssh_opts("22", DEFAULT_USER_IDENTITY, []))} {address}'),
]

@pytest.mark.parametrize('opts,output', ssh_outputs)
def test_ssh(runner, opts, output):
    result = runner.invoke(cli, ['--no-creds', '--dry-run', 'bastion', 'ssh', workspace] + opts)
    assert result.exit_code == 0
    assert output in result.output
