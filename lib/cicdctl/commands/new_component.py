import click

from ..utils.terraform.templates.driver import TemplateDriver

"""cicdctl console"""

@click.command()
@click.pass_obj
@click.option('--workspaced', is_flag=True, default=False)
@click.argument('component')
def new_component(settings, workspaced, component):
    TemplateDriver(settings).new(workspaced, component)
