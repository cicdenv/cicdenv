import click

from .types.cluster import ClusterParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials
from ..utils.kubernetes.kops_cluster.drivers import AuthenticatorDriver

"""cicdctl aws-iam-authenticator token <cluster> ..."""

@click.group()
@click.pass_obj
def aws_iam_authenticator(settings):
    # Refresh main account AWS sts creds
    if settings.creds:
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh('main')

@aws_iam_authenticator.command()
@click.pass_obj
@click.argument('cluster', type=ClusterParamType())
def token(settings, cluster):
    if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh(cluster.workspace)
    AuthenticatorDriver(settings, cluster).token()
    