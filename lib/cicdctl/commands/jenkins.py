import click

from . import PASS_THRU_FLAGS, commands
from .types.instance import InstanceParamType
from .types.flag import FlagParamType

from ..utils.aws.credentials import StsAssumeRoleCredentials
from ..utils.jenkins.driver import JenkinsDriver

"""cicdctl jenkins <command> <instance-name:workspace> [tf-options|tf-vars|options]"""

@click.group()
@click.pass_obj
def jenkins(settings):
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
        @click.option('--type', '_type', type=click.Choice(['colocated', 'distributed'], case_sensitive=False), required=True)
        @click.argument('flags', nargs=-1, type=FlagParamType())
        def command_func(settings, instance, _type, flags):
            if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
                sts = StsAssumeRoleCredentials(settings)
                sts.refresh(instance.workspace)
            driver_method = getattr(JenkinsDriver(settings, instance, flags=flags, type=_type), command)
            driver_method()
        command_func.__name__ = command
    
        jenkins.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)

for command in [command for command in commands(__file__) if command in [
        'start',
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
            driver_method = getattr(JenkinsDriver(settings, instance, flags=flags), command)
            driver_method()
        command_func.__name__ = command
    
        jenkins.command(name=command, context_settings=PASS_THRU_FLAGS)(command_func)
    bind_command(command)

@jenkins.command(context_settings=PASS_THRU_FLAGS)
@click.pass_obj
@click.argument('instance', type=InstanceParamType())
def stop(settings, instance):
    if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh(instance.workspace)
    JenkinsDriver(settings, instance).stop()

@jenkins.command(context_settings=PASS_THRU_FLAGS)
@click.pass_obj
@click.argument('instance', type=InstanceParamType())
@click.option('--image-tag')
def deploy(settings, instance, image_tag):
    if settings.creds:  # Refreshes sub account AWS mfa credentials if needed
        sts = StsAssumeRoleCredentials(settings)
        sts.refresh(instance.workspace)
    if image_tag:
        JenkinsDriver(settings, instance, flags=['--image-tag', image_tag]).deploy()
    else:
        JenkinsDriver(settings, instance).deploy()
