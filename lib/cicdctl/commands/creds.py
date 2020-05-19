import click

from . import PASS_THRU_FLAGS
from .types.workspace import WorkspaceParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials, MfaCodeGenerator

"""cicdctl creds <command>"""

@click.group()
@click.pass_obj
def creds(settings):
    pass


@creds.command(context_settings=PASS_THRU_FLAGS)
@click.pass_obj
@click.argument('workspaces', type=WorkspaceParamType(), nargs=-1)
def aws_mfa(settings, workspaces):
    if settings.creds:
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh('main')
        for workspace in workspaces:
            if workspace != 'main':
                sts.refresh(workspace)


@creds.command(context_settings=PASS_THRU_FLAGS)
@click.pass_obj
def mfa_code(settings):
    if settings.creds:
        print(MfaCodeGenerator().next())
