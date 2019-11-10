from sys import stdout, stderr
from os import getcwd, environ
import subprocess

from cicdctl.logs import log_cmd_line


def run_new(args):
    environment = environ.copy()  # Inherit cicdctl's environment

    for _state in args.state:
        _script = None
        if args.new_command == 'main-state':
            _script = 'terraform/bin/new-main-state.sh'
        elif args.new_command == 'workspaced-state':
            _script = 'terraform/bin/new-workspaced-state.sh'

        gen_cmd = [_script, _state]
        log_cmd_line(gen_cmd)
        subprocess.run(gen_cmd, env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)
