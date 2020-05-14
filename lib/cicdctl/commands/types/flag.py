import click

class FlagParamType(click.ParamType):
    name = 'flag'

    def convert(self, value, param, context):
        return value
