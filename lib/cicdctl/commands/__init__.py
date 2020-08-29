import sys
from os.path import basename, splitext
from pathlib import Path
import inspect
import pkgutil
from importlib import import_module

# Accept remaing command line tokens
PASS_THRU_FLAGS = {
    "ignore_unknown_options": True,
}

COMMANDS = {
    'aws-iam-authenticator': [
        'token',
    ],
    'bastion': [
        'ssh',
    ],
    'cluster': [
        'init',
        'create',
        'destroy',
        'validate',
        'start',
        'stop',
    ],
    'console': [
    ],
    'creds': [
        'aws-mfa',
        'mfa-code',
    ],
    'jenkins': [
        'init',
        'create',
        'destroy',
        'start',
        'stop',
        'deploy',
    ],
    'kops': [
    ],
    'kubectl':[
    ],
    'new-component': [
    ],
    'mysql': [
        'init',
        'create',
        'destroy',
    ],
    'nginx': [
        'init',
        'create',
        'destroy',
    ],
    'packer': [
        'validate',
        'build',
        'console',
    ],
    'redis': [
        'init',
        'create',
        'destroy',
    ],
    'terraform': [
        'fmt',
        'validate',
        'output',
        'unlock',
        'init',
        'plan',
        'show',
        'apply',
        'destroy',
        'refresh',
        'import',
        'taint',
        'untaint',
        'state',
        'console',
        '0.13upgrade',
    ],
    'test': [
    ],
    'allowed-networks': [
        'list',
        'add',
        'remove',
    ],
}


def add_commands(cli):
    """Connects <module>.<function> group/command "sub-commands" to the main click "cli".

    "Discovers" commands/<module>::<function> pairs where 'module name' == 'function name' 

    Keyword arguments:
    cli -- click.Group decorator top level function
    """
    commands_package = [Path(__file__).parent]
    for (_, command_module, _) in pkgutil.iter_modules(commands_package):
        imported_module = import_module('.' + command_module, package=__name__)
        if hasattr(imported_module, command_module):
            sub_command = getattr(imported_module, command_module)
            setattr(sys.modules[__name__], command_module, sub_command)
            cli.add_command(sub_command)


def commands(pyfile):
    command = splitext(basename(pyfile))[0]
    return COMMANDS[command]
