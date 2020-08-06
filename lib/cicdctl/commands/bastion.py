import click

from . import PASS_THRU_FLAGS, commands
from .types.workspace import WorkspaceParamType
from .types.flag import FlagParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials
from ..utils.bastion.driver import BastionDriver
from ..utils.aws import iam

"""cicdctl bastion <command> <workspace> [options]"""

@click.group()
@click.pass_obj
def bastion(settings):
    # Refresh main account AWS sts creds
    if settings.creds:
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh('main')

    
for command in commands(__file__):
    def bind_command(command):
        @click.pass_obj
        @click.option('--user')
        @click.option('--host', is_flag=True, default=False)
        @click.option('--ip')
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, user, host, ip, flags):
            if user == None:
                user = iam.get_username()
            driver_method = getattr(BastionDriver(settings, user, host, ip, flags), command)
            driver_method()
        command_func.__name__ = command
    
        bastion.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)
