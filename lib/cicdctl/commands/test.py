import click

from . import PASS_THRU_FLAGS
from .types.flag import FlagParamType

from ..utils.python.drivers import TestDriver

"""cicdctl test [pytest-options]"""

@click.command(context_settings=PASS_THRU_FLAGS)
@click.pass_obj
@click.argument('flags', nargs=-1, type=FlagParamType())
def test(settings, flags):
    TestDriver(settings, flags).test()
