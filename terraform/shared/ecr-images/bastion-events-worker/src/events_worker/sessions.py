import subprocess

import docker


# [
#   '014719181291.dkr.ecr.us-west-2.amazonaws.com/bastion-sshd-worker:latest', 
#   'sshd-worker:latest',
# ]
def _image_name(tag):
    repo_name = str(tag).split(':')[0]
    image_name = repo_name.split('/')[-1]
    return image_name


def _get_session_user(container):
    try:
        return subprocess.check_output(['docker', 'exec', '-i', f'{container.id}', 'bash', '-c', 'ls /home'], text=True).strip()
    except subprocess.CalledProcessError as cpe:
        print(cpe)
        return None


def stop_workers(username):
    client = docker.from_env()
    for container in client.containers.list():
        # container: id=260bbdcacf, image=['014719181291.dkr.ecr.us-west-2.amazonaws.com/bastion-sshd-worker:latest', 'sshd-worker:latest']
        print(f'container: id={container.short_id}, image={container.image.tags}')
        for image_name in [_image_name(tag) for tag in container.image.tags]:
            if image_name == 'sshd-worker':
                if username == _get_session_user(container):
                    print(f'closing session: user={username}, container: {image_name}/{container.short_id}')
                    container.stop()
