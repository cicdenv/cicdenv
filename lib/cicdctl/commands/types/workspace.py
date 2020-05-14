import click

class WorkspaceParamType(click.ParamType):
    name = 'workspace'

    def convert(self, value, param, context):
        return value
