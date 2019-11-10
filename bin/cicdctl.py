#!/usr/bin/env python

import sys
sys.path.append('lib')

from argparse import ArgumentTypeError
import logging
import os

from cicdctl.args import parse_command_line
from cicdctl.logs import config_logging


def main():
    args = parse_command_line()
    config_logging(args)

    try:
    	args.func(args)
    except ArgumentTypeError as e:
    	sys.stderr.write(str(e) + '\n')
    	sys.exit(1)
    except KeyboardInterrupt:
    	sys.exit(1)


if __name__ == "__main__":
    main()
