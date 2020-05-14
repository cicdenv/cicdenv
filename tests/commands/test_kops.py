import pytest
from click.testing import CliRunner
from cicdctl import cli

from cicdctl.commands.types.cluster import parse_cluster
from cicdctl.utils.kubernetes.kops_cluster import cluster_fqdn

cluster = parse_cluster('1-18a:dev')

kops_outputs = [
    (str(cluster), ['export', 'kubecfg'], f'kops export kubecfg --name={cluster_fqdn(cluster.name, cluster.workspace)}'),
]


@pytest.mark.parametrize('cluster,opts,output', kops_outputs)
def test_command(runner, cluster, opts, output):
    result = runner.invoke(cli, ['--no-creds', '--dry-run', 'kops', cluster] + opts)
    assert result.exit_code == 0
    assert output in result.output
