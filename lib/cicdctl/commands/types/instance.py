import click

from collections import namedtuple


class Instance(namedtuple('Instance', ['name', 'workspace'])):
    def __str__(self):
        return f'{self.name}:{self.workspace}'


def parse_instance(value):
    """Parses a command line "instance" value into its name, workspace parts.

    Keyword arguments:
    value -- <instance-name>:<workspace>, cluster-name is limited to 15 chars max, [-a-z] chars
    """
    parts = value.split(':')
    # TODO validate - must have 2 parts
    name = parts[0]
    workspace = parts[1]
    return Instance(name, workspace)


class InstanceParamType(click.ParamType):
    name = 'instance'

    def convert(self, value, param, context):
        return parse_instance(value)
