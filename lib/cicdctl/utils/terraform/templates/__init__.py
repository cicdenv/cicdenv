from os import environ

workspaced_script = 'terraform/bin/new-workspaced-state.sh'
non_workspaced_script = 'terraform/bin/new-main-state.sh'


def env(environment=environ.copy()):  # Inherits cicdctl's environment by default
    return environment
