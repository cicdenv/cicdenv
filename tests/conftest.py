import pytest

from cicdctl import cli
from cicdctl.commands import add_commands

from click.testing import CliRunner


@pytest.fixture(scope="function")
def runner(request):
    return CliRunner()


#
# "Discover" and wire up all sub-command "plugins"
#
add_commands(cli)
