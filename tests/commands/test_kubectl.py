import pytest
from click.testing import CliRunner
from cicdctl import cli

cluster = '1-18a:dev'

kubectl_outputs = [
    ([], 'kubectl'),
    (['get', 'pods'], 'kubectl get pods'),
    (['get', 'pods', '-n', 'kube-system'], 'kubectl get pods -n kube-system'),
]


@pytest.mark.parametrize('opts,output', kubectl_outputs)
def test_command(runner, opts, output):
    result = runner.invoke(cli, ['--no-creds', '--dry-run', 'kubectl', cluster] + opts)
    assert result.exit_code == 0
    assert output in result.output
