import click

from ..utils.shell.driver import ShellDriver

"""cicdctl console"""

@click.command()
@click.pass_obj
def console(settings):
    ShellDriver(settings).bash()
