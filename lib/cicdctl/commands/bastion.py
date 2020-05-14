import getpass

import click

from . import PASS_THRU_FLAGS, commands
from .types.workspace import WorkspaceParamType
from .types.flag import FlagParamType

from ..utils.bastion.driver import BastionDriver

"""cicdctl bastion <command> <workspace> [options]"""

@click.group()
@click.pass_obj
def bastion(settings):
    pass

    
for command in commands(__file__):
    def bind_command(command):
        @click.pass_obj
        @click.argument('workspace', type=WorkspaceParamType())
        @click.option('--user', default=getpass.getuser())
        @click.option('--host', is_flag=True, default=False)
        @click.option('--jump')
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, workspace, user, host, jump, flags):
            driver_method = getattr(BastionDriver(settings, workspace, user, host, jump, flags), command)
            driver_method()
        command_func.__name__ = command
    
        bastion.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)
