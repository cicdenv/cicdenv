import click

from collections import namedtuple


class Group(namedtuple('Group', ['name', 'workspace'])):
    def __str__(self):
        return f'{self.name}:{self.workspace}'


def parse_group(value):
    """Parses a command line "group" value into its name, workspace parts.

    Keyword arguments:
    value -- <group-name>:<workspace>, cluster-name is limited to 15 chars max, [-a-z] chars
    """
    parts = value.split(':')
    # TODO validate - must have 2 parts
    name = parts[0]
    workspace = parts[1]
    return Group(name, workspace)


class GroupParamType(click.ParamType):
    name = 'group'

    def convert(self, value, param, context):
        return parse_group(value)
