from os import environ
import json
from base64 import b64decode

import boto3
import botocore


def get_secrets(secret_id=environ["SECRET_ID"]):
    secretmanager = boto3.client('secretsmanager')
    secret = json.loads(secretmanager.get_secret_value(SecretId=secret_id)['SecretString'])

    key_id = secret['key-id']
    passphrase = secret['key-passphrase']
    public_key = b64decode(secret['public-key']).decode()
    private_key = b64decode(secret['private-key']).decode()
    
    return key_id, passphrase, public_key, private_key


if __name__ == "__main__":
    key_id, passphrase, public_key, private_key = get_secrets()
    for item in ['key_id', 'passphrase', 'public_key', 'private_key']:
        print(f'{item} => {locals()[item]}')
