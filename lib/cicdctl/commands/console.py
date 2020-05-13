from sys import stdout, stderr
from os import path, getcwd, environ
import subprocess

from cicdctl.logs import log_cmd_line


def run_console(args):
    _PS1='\\u:\\w\\$ '  # Default prompt string
    with open(path.join(getcwd(), 'tool-vars'), 'r') as f:
        for line in f:
            if line.startswith('_PS1='):
                # Strip assingment, quotes, make dollar escapes
                _PS1=line.replace("_PS1=", '').rstrip().replace("'", '').replace("$$", '$')
                break

    environment = environ.copy()  # Inherit cicdctl's environment
    environment['PS1'] = _PS1

    try:
        cmd = ['bash']
        log_cmd_line(cmd)
        
        subprocess.run('bash', env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)
    except subprocess.CalledProcessError as cpe:
        exit(cpe.returncode)
