from sys import exit, stdout, stderr
from os import path, getcwd, environ
import subprocess

import json


def get_outputs(workspace, state):
    environment = environ.copy()  # Inherit cicdctl's environment

    # Set aws credentials profile with env variables
    environment['AWS_PROFILE'] = f'admin-{workspace}'

    state_dir = path.join(getcwd(), 'terraform', state)
    json_stdout = subprocess.check_output(['terraform', 'output', '-json'], env=environment, cwd=state_dir).decode('utf-8')
    return json.loads(json_stdout)


def get_output(workspace, state, output):
    return get_outputs(workspace, state)[output]['value']
