from os import path, getcwd, environ

from ..runners import EnvironmentContext

def env(environment=environ.copy()):  # Inherits cicdctl's environment by default
    # Add lib/ folder to python module lookup path
    lib_dir = path.join(getcwd(), 'lib')
    if 'PYTHONPATH' not in environment or lib_dir not in environment['PYTHONPATH'].split(':'):
        environment['PYTHONPATH'] = lib_dir

    logged_keys = ['PYTHONPATH']
    return EnvironmentContext(environment, logged_keys)
