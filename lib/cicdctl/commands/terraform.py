import click

from . import PASS_THRU_FLAGS, commands
from .types.target import TargetParamType
from .types.flag import FlagParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials
from ..utils.terraform.driver import TerraformDriver

"""cicdctl terraform <sub-command> <target> [tf-options]"""

@click.group()
@click.pass_obj
def terraform(settings):
    # Refresh main account AWS sts creds
    if settings.creds:
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh('main')

    
for command in commands(__file__):
    def bind_command(command):
        @click.pass_obj
        @click.argument('target', type=TargetParamType())
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, target, flags):
            if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
                sts = StsAssumeRoleCredentials(settings)
                sts.refresh(target.workspace)
            driver_method = getattr(TerraformDriver(settings, target, flags), command)
            driver_method()
        command_func.__name__ = command
    
        terraform.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)
