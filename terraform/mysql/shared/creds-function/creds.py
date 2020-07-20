from uuid import uuid4
from base64 import b64encode


def create_passwords():
    return {
        'root-password': str(uuid4()),
        'replication-password': str(uuid4()),
        'backup-password': str(uuid4()),
    }
