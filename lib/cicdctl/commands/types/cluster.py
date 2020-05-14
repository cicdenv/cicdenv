import click

from collections import namedtuple


class Cluster(namedtuple('Cluster', ['name', 'workspace'])):
    def __str__(self):
        return f'{self.name}:{self.workspace}'


def parse_cluster(value):
    """Parses a command line "cluster" value into its name, workspace parts.

    Keyword arguments:
    value -- <cluster-name>:<workspace>, cluster-name is limited to 15 chars max, [-a-z] chars
    """
    parts = value.split(':')
    # TODO validate - must have 2 parts
    name = parts[0]
    workspace = parts[1]
    return Cluster(name, workspace)


class ClusterParamType(click.ParamType):
    name = 'cluster'

    def convert(self, value, param, context):
        return parse_cluster(value)
