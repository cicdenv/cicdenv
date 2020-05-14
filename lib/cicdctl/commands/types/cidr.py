import click

class CIDRParamType(click.ParamType):
    name = 'cidr'

    def convert(self, value, param, context):
        return value
