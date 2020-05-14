from os import path, getcwd

ansible_dir = path.join(getcwd(), 'terraform/jenkins/ansible')


def playbook_actions(type, private_ips, server_image_tag, agent_image_tag):
    if type == 'distributed':
        return [
            {
                'playbook': 'start.yml',
                'hosts': [private_ips[0]],
            },
            {
                'playbook': 'server.yml',
                'hosts': [private_ips[0]],
                'vars': {
                    'jenkins_server_tag': server_image_tag,
                    'jenkins_agent_tag': agent_image_tag,
                }
            },
            {
                'playbook': 'agent.yml',
                'hosts': private_ips[1:],
                'vars': {
                    'jenkins_server_tag': server_image_tag,
                    'jenkins_agent_tag': agent_image_tag,
                }
            },
            {
                'playbook': 'end.yml',
                'hosts': [private_ips[0]],
            },
        ]
    if type == 'colocated':
        return [
            {
                'playbook': 'start.yml',
                'hosts': [private_ips[0]],
            },
            {
                'playbook': 'colocated.yml',
                'hosts': [private_ips[0]],
                'vars': {
                    'jenkins_server_tag': server_image_tag,
                    'jenkins_agent_tag': agent_image_tag,
                }
            },
            {
                'playbook': 'end.yml',
                'hosts': [private_ips[0]],
            },
        ]
