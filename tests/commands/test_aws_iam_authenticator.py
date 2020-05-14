import pytest
from click.testing import CliRunner
from cicdctl import cli

from cicdctl.commands.types.cluster import parse_cluster
from cicdctl.utils.kubernetes.kops_cluster import cluster_fqdn

cluster = parse_cluster('1-18a:dev')

authenticator_outputs = [
    (str(cluster), f'aws-iam-authenticator token -i {cluster_fqdn(cluster.name, cluster.workspace)}'),
]


@pytest.mark.parametrize('cluster,output', authenticator_outputs)
def test_command(runner, cluster, output):
    result = runner.invoke(cli, ['--no-creds', '--dry-run', 'aws-iam-authenticator', 'token', cluster])
    assert result.exit_code == 0
    assert output in result.output
