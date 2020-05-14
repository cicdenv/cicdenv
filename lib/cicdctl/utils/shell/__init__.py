from os import path, getcwd, environ

from ..aws import DEFAULT_REGION


def env(environment=environ.copy()):  # Inherits cicdctl's environment by default
    # Set default aws region
    environment['AWS_DEFAULT_REGION'] = DEFAULT_REGION
    
    _PS1='\\u:\\w\\$ '  # Default prompt string
    with open(path.join(getcwd(), 'tool-vars.mk'), 'r') as f:
        for line in f:
            if line.startswith('_PS1='):
                # Strip assingment, quotes, make dollar escapes
                _PS1=line.replace("_PS1=", '').rstrip().replace("'", '').replace("$$", '$')
                break

    environment['PS1'] = _PS1

    return environment
