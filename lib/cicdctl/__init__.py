from sys import stdout
import logging
from collections import namedtuple

import click

from .utils.runners import SubprocessRunnerFactory

VERBOSE_HELP = 'Turns on verbose logging to "stdout"'
QUIET_HELP = 'Turns off command logging to "stderr" in interactive sessions'
NOCREDS_HELP = 'Turns off automatic AWS+mfa sts credential renewal'
DRYRUN_HELP = "Prints but does execute actions"

_settings_fields = ' '.join(['verbose', 'quiet', 'creds', 'dry_run'])
Settings = namedtuple('Settings', _settings_fields)

_runtime_settings_fields = _settings_fields + ' ' + 'runner'
RuntimeSettings = namedtuple('RuntimeSettings', _runtime_settings_fields)


@click.group()
@click.pass_context
@click.option('-v', '--verbose', is_flag=True, help=VERBOSE_HELP, default=False)
@click.option('-q', '--quiet', is_flag=True, help=QUIET_HELP, default=False)
@click.option('--no-creds', is_flag=True, help=NOCREDS_HELP, default=False)
@click.option('--dry-run', is_flag=True, help=DRYRUN_HELP, default=False)
def cli(context, verbose, quiet, no_creds, dry_run):
    creds = False if no_creds else True
    
    settings = Settings(verbose, quiet, creds, dry_run)
    runner = SubprocessRunnerFactory(settings)
    
    context.obj = RuntimeSettings(verbose, quiet, creds, dry_run, runner)

    logging.basicConfig(format='%(message)s', level=logging.INFO, stream=stdout)
