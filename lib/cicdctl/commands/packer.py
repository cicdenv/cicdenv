import click

from . import PASS_THRU_FLAGS, commands
from .types.flag import FlagParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials
from ..utils.packer.driver import PackerDriver

"""cicdctl packer <sub-command> [packer-options]"""

@click.group()
@click.pass_obj
def packer(settings):
    # Refresh main account AWS sts creds
    if settings.creds:
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh('main')

   
for command in commands(__file__):
    def bind_command(command):
        @click.pass_obj
        @click.option('--fs', type=click.Choice(['none', 'ext4', 'zfs'], case_sensitive=False), required=True)
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, fs, flags):
            driver_method = getattr(PackerDriver(settings, fs, flags), command)
            driver_method()
        command_func.__name__ = command
    
        packer.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)
