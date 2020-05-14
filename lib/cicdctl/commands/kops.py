import click

from . import PASS_THRU_FLAGS
from .types.cluster import ClusterParamType
from .types.flag import FlagParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials
from ..utils.kubernetes.kops_cluster.drivers import KopsDriver

"""cicdctl kops <cluster> [--admin] ..."""

@click.command(context_settings=PASS_THRU_FLAGS)
@click.pass_obj
@click.argument('cluster', type=ClusterParamType())
@click.option('--admin', is_flag=True, default=False)
@click.argument('flags', nargs=-1, type=FlagParamType())
def kops(settings, cluster, admin, flags):
    if settings.creds:  # Refreshes main/sub account AWS mfa credentials if needed
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh('main')
        sts.refresh(cluster.workspace)
    KopsDriver(settings, cluster, admin).run(flags)
