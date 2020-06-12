import click

from . import PASS_THRU_FLAGS, commands
from .types.instance import InstanceParamType
from .types.flag import FlagParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials
from ..utils.redis.driver import RedisDriver

"""cicdctl redis <command> <cluster-name:workspace> [tf-options|tf-vars]"""

@click.group()
@click.pass_obj
def redis(settings):
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
        @click.argument('instance', type=InstanceParamType())
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, instance, flags):
            if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
                sts = StsAssumeRoleCredentials(settings)
                sts.refresh(instance.workspace)
            driver_method = getattr(RedisDriver(settings, instance, flags=flags), command)
            driver_method()
        command_func.__name__ = command
    
        redis.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)

for command in [command for command in commands(__file__) if command in [
        'destroy',
    ]]:
    def bind_command(command):
        @click.pass_obj
        @click.argument('instance', type=InstanceParamType())
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, instance, flags):
            if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
                sts = StsAssumeRoleCredentials(settings)
                sts.refresh(instance.workspace)
            driver_method = getattr(RedisDriver(settings, instance, flags=flags), command)
            driver_method()
        command_func.__name__ = command
    
        redis.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)
