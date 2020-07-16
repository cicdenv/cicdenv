from os import path, environ
import re

from ..runners import EnvironmentContext
from ..terraform import parse_tfvars, domain_config, bastion_config

from ..ssh import default_ssh_key

DEFAULT_USER_IDENTITY = path.expanduser('~/.ssh/id_rsa')

_ssh_opts = {
    'StrictHostKeyChecking': 'no',
    'UserKnownHostsFile': '/dev/null',
    'IdentitiesOnly': 'yes',
    'LogLevel': 'ERROR',
    'ForwardAgent': 'true',
    'ConnectTimeout': '15',
    'ServerAliveInterval': '60',
    'ServerAliveCountMax': '120',
}

# ip-10-16-111-42.us-west-2.compute.internal
_aws_hostname_pattern = re.compile(r'ip-(\d+)-(\d+)-(\d+)-(\d+).\w+-\w+-\d+.compute.internal')


def ssh_opts(port, identity, flags):
    # merge custom -o key=value options with defaults
    _ssh_opts_overrides = {}
    for k, v in zip(flags[0::2], flags[1::2]):
        if k == '-o':
            parts = v.split('=')
            key = parts[0]
            value = parts[1]
            _ssh_opts_overrides[key] = value
    _ssh_opts_merged = {**_ssh_opts, **_ssh_opts_overrides}

    # any non -o key=value options
    _ssh_args = {  # port, identity can be overriden
        '-p': str(port), 
        '-i': identity,
    }
    for k, v in zip(flags[0::2], flags[1::2]):
        if k != '-o':
            _ssh_args[k] = v

    # get '-o' opts into ['-o', '<key>=<value>', ...] form
    opts = []
    for key, value in _ssh_opts_merged.items():
        opts.append('-o')
        opts.append(f'{key}={value}')
    # add non '-o' options
    for arg, value in _ssh_args.items():
        opts.append(arg)
        opts.append(value)
    return opts


def bastion_address(user, workspace):
    domain = parse_tfvars(domain_config)['domain']
    address = f'{user}@bastion.{workspace}.{domain}'
    return address


def ssh_cmd(cmd, user, port, identity, ip, workspace, flags):
    _bastion = bastion_address(user, workspace)
    if ip:
        _aws_hostnam_matched = _aws_hostname_pattern.match(ip)
        if _aws_hostnam_matched:  # handle aws default private hostnames
            address = f'ubuntu@{".".join(_aws_hostnam_matched.groups())}'
        else:
            address = f'ubuntu@{ip}'
        proxy_opts = f'ProxyCommand=ssh {" ".join(ssh_opts(port, DEFAULT_USER_IDENTITY, flags))} -W %h:%p {_bastion}'
        return [cmd] + ssh_opts(port, default_ssh_key(workspace), flags) + ['-o', proxy_opts, address]
    else:
        address = _bastion
        return [cmd] + ssh_opts(port, identity, flags) + [address]

def env():
    environment=environ.copy()  # Inherits cicdctl's environment by default

    logged_keys = ['SSH_AUTH_SOCK']
    return EnvironmentContext(environment, logged_keys)
