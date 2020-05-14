import click

from . import commands
from .types.cidr import CIDRParamType

from ..utils.whitelist.driver import WhitelistDriver

"""cicdctl whitelist <sub-command> [options]"""

@click.group()
@click.pass_obj
def whitelist(settings):
    pass


@whitelist.command()
@click.pass_obj
def list(settings):
    WhitelistDriver(settings).list()

   
for command in [command for command in commands(__file__) if command in ['add', 'remove']]:
    def bind_command(command):
        @click.pass_obj
        @click.option('--cidr', type=CIDRParamType())
        def command_func(settings, cidr):
            driver_method = getattr(WhitelistDriver(settings), command)
            driver_method(cidr)
        command_func.__name__ = command
    
        whitelist.command(name=command)(command_func)
    bind_command(command)
