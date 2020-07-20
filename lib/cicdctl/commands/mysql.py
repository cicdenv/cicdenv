import click

from . import PASS_THRU_FLAGS, commands
from .types.group import GroupParamType
from .types.flag import FlagParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials
from ..utils.mysql.driver import MySQLDriver

"""cicdctl mysql <command> <cluster-name:workspace> [tf-options|tf-vars]"""

@click.group()
@click.pass_obj
def mysql(settings):
    # Refresh main account AWS sts creds
    if settings.creds:
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh('main')

  
for command in [command for command in commands(__file__) if command in [
        'init',
        'create',
    ]]:
    def bind_command(command):
        @click.pass_obj
        @click.argument('group', type=GroupParamType())
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, group, flags):
            if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
                sts = StsAssumeRoleCredentials(settings)
                sts.refresh(group.workspace)
            driver_method = getattr(MySQLDriver(settings, group, flags=flags), command)
            driver_method()
        command_func.__name__ = command
    
        mysql.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)

for command in [command for command in commands(__file__) if command in [
        'destroy',
    ]]:
    def bind_command(command):
        @click.pass_obj
        @click.argument('group', type=GroupParamType())
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, group, flags):
            if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
                sts = StsAssumeRoleCredentials(settings)
                sts.refresh(group.workspace)
            driver_method = getattr(MySQLDriver(settings, group, flags=flags), command)
            driver_method()
        command_func.__name__ = command
    
        mysql.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)
