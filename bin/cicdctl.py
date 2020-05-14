#!/usr/bin/env python

import sys
sys.path.append('lib')

from cicdctl import cli
from cicdctl.commands import add_commands

if __name__ == "__main__":
    add_commands(cli)
    cli()
