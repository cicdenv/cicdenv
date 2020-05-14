import click

from collections import namedtuple


DEFAULT_WORKSPACE = 'main'


class Target(namedtuple('Target', ['component', 'workspace'])):
    def __str__(self):
        return f'{self.component}:{self.workspace}'


def parse_target(value):
    """Parses a command line "target" value into its component, workspace parts.

    Keyword arguments:
    value -- <terraform-component>:<workspace>, component is relative to terraform/ folder
    """
    parts = value.split(':')
    component = parts[0]
    workspace = parts[1] if len(parts) >= 2 else DEFAULT_WORKSPACE
    return Target(component, workspace)


class TargetParamType(click.ParamType):
    name = 'target'

    def convert(self, value, param, context):
        return parse_target(value)
