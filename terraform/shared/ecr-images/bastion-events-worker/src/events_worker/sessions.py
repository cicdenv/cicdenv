import subprocess

import docker
import redis

# [
#   '014719181291.dkr.ecr.us-west-2.amazonaws.com/bastion-sshd-worker:latest', 
#   'sshd-worker:latest',
# ]
def _image_name(tag):
    repo_name = str(tag).split(':')[0]
    image_name = repo_name.split('/')[-1]
    return image_name


def _get_session_user(container):
    _key = f'{container.id}'

    r = redis.Redis(unix_socket_path='/var/run/redis/sock', username='events-worker', password='events-worker')
    session_user = r.get(_key)
    if session_user:
        r.delete(_key)
    return session_user.decode()


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
