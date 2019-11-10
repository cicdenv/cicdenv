import logging

from os import getcwd


def config_logging(args):
    logging.basicConfig(format='%(message)s', level=logging.INFO)


def log_cmd_line(command_line, cwd=None):
    cmd_line = ''
    if cwd is not None:
        # Print shell command equivalient of what we're doing
        path = cwd.replace(f'{getcwd()}/', '')
        cmd_line = f'(cd {path}; {" ".join(command_line)})'
    else:
        cmd_line = command_line
    
    logging.getLogger("cicdctl").info(cmd_line)
