#!/usr/bin/python

from os import path, environ
from pathlib import Path
from time import time

from ansible.module_utils.basic import AnsibleModule

from jenkins import Jenkins
import jenkinsapi

NORMAL_TIMEOUT = 30 # seconds
RUNNING_JOBS_TIMEOUT = 300 # seconds


def inspect_server(server, result):
    info = server.get_info()
    result['mode'] = info['mode']

    version = server.get_version()
    result['version'] = version

    return info, version


def main():
    module_args = {
        'api': {
            'type': 'str',
            'required': False
        },
        'wait_for': {
            'type':    'str',
            'required': False,
        },
    }

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    result = { 
        'changed' :False,
    }

    # format: <github-user>:<github-token>
    auth_file = path.join(Path.home(), ".jenkins/auth")
    with open(auth_file) as af:
        auth = [line.strip() for line in af if not line.strip().startswith("#")]
    github_user, github_token = auth[0].split(":")

    # jenkins server name
    instance = environ['INSTANCE']
    workspace = environ['WORKSPACE']
    domain = environ['DOMAIN']
    server_name = f'https://jenkins-{instance}.{workspace}.{domain}'

    server = Jenkins(server_name, username=github_user, password=github_token, timeout=10)

    if module.params['api']:
        info, _ = inspect_server(server, result)

        if module.params['api'] == "/quietDown":
            if info['quietingDown'] == True:
                module.exit_json(**result)  # Already quiesced
            if not module.check_mode:
                server.quiet_down()
            result['changed'] = True
            module.exit_json(**result)
    elif module.params['wait_for']:
        if module.params['wait_for'] == 'normal_operation':
            info = {}
            try:
                info, _ = inspect_server(server, result)
            except:
                pass

            if 'mode' in info and info['mode'] == "NORMAL":
                serverAPI = jenkinsapi.jenkins.Jenkins(server_name, username=github_user, password=github_token, timeout=10, useCrumb=True)
                if serverAPI.is_quieting_down:
                    serverAPI.cancel_quiet_down()
                    result['changed'] = True
                module.exit_json(**result)  # Already operating normally
            if server.wait_for_normal_op(NORMAL_TIMEOUT):
                result['changed'] = True
                module.exit_json(**result)  # Successfully waited
            else:  # Waiting failed
                module.fail_json(msg=f'Timeout waiting for server transition to NORMAL operation mode ({NORMAL_TIMEOUT}s)', **result)
        elif module.params['wait_for'] == 'running_jobs':
            info, _ = inspect_server(server, result)

            running_builds = server.get_running_builds()
            if len(running_builds) == 0:
                module.exit_json(**result)  # No jobs running
            else:
                result['changed'] = True
                if not module.check_mode:
                    _start = time()
                    while time() < _start + RUNNING_JOBS_TIMEOUT:
                        running_builds = server.get_running_builds()
                        if len(running_builds) == 0:
                            module.exit_json(**result)  # Successfully waited for running jobs to end
            # Jobs still running, fail
            module.fail_json(msg=f'Timeout waiting for running jobs to complete ({RUNNING_JOBS_TIMEOUT}s)', **result)


if __name__ == '__main__':
    main()
