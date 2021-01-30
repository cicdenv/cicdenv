import click

from . import commands
from .types.cidr import CIDRParamType

from ..utils.allowed_networks.driver import AllowedNetworksDriver

"""cicdctl allowed-networks <sub-command> [options]"""

@click.group()
@click.pass_obj
def allowed_networks(settings):
    pass


@allowed_networks.command()
@click.pass_obj
def list(settings):
    AllowedNetworksDriver(settings).list()

   
for command in [command for command in commands(__file__.replace('_', '-')) if command in ['add', 'remove']]:
    def bind_command(command):
        @click.pass_obj
        @click.option('--cidr', type=CIDRParamType(), required=True)
        def command_func(settings, cidr):
            driver_method = getattr(AllowedNetworksDriver(settings), command)
            driver_method(cidr)
        command_func.__name__ = command
    
        allowed_networks.command(name=command)(command_func)
    bind_command(command)
