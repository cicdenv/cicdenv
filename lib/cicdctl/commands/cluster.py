import click

from . import PASS_THRU_FLAGS, commands
from .types.cluster import ClusterParamType
from .types.flag import FlagParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials
from ..utils.kubernetes.kops_cluster.drivers import ClusterDriver

"""cicdctl cluster <command> <cluster> [tf-options|vars]"""

@click.group()
@click.pass_obj
def cluster(settings):
    # Refresh main account AWS sts creds
    if settings.creds:
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh('main')

  
for command in commands(__file__):
    def bind_command(command):
        @click.pass_obj
        @click.argument('cluster', type=ClusterParamType())
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, cluster, flags):
            if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
                sts = StsAssumeRoleCredentials(settings)
                sts.refresh(cluster.workspace)
            driver_method = getattr(ClusterDriver(settings, cluster, flags), command)
            driver_method()
        command_func.__name__ = command
    
        cluster.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)
