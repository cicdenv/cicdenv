#!/usr/bin/env python

import sys
sys.path.append('lib')

from os.path import basename, splitext

from cicdctl import cli
from cicdctl.commands import add_commands

usage_name = splitext(basename(__file__))[0]

if __name__ == "__main__":
    add_commands(cli)
    cli(prog_name=usage_name)
