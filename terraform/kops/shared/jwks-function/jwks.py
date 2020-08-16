from sys import stdout, stderr
from subprocess import check_call, check_output
from os import path, remove, makedirs

from base64 import b64encode
import json
from uuid import uuid4

def _base64_string(file):
    return b64encode(open(file).read().encode()).decode()


def create_jwks(prefix):
    output_dir = f'{prefix}/{str(uuid4())}'
    makedirs(output_dir, exist_ok=True)

    # Create the service account signing key pair
    keygen_cmds = [
        f'ssh-keygen -t rsa -b 2048 -f {output_dir}/irsa-key -m pem -q -N "" <<<"y"',
        f'ssh-keygen -e -m PKCS8 -f {output_dir}/irsa-key.pub > {output_dir}/irsa-pkcs8.pub <<<"y"',
    ]
    for keygen_cmd in keygen_cmds:
        print(keygen_cmd)
        check_call(args=keygen_cmd, shell=True, stdin=None, stdout=stdout, stderr=stderr)


    # jwks.json
    jwks_cmd = f'jwks -key {output_dir}/irsa-pkcs8.pub'
    print(jwks_cmd)
    jwks_json = check_output(args=jwks_cmd, shell=True, stdin=None, stderr=stderr)
    print(jwks_json.decode())
    key_settings = json.loads(jwks_json)["keys"][0]
    _key_settings = dict(key_settings)
    _key_settings["kid"] = ""
    jwks_settings = {
        "keys": [
            key_settings,
            _key_settings,
        ]
    }
    jwks_settings_json = json.dumps(jwks_settings)
    print(jwks_settings_json)

    # Return
    return {
        'account-signing-key': _base64_string(f'{output_dir}/irsa-key'),
        'account-signing-key.pub': _base64_string(f'{output_dir}/irsa-key.pub'),
        'account-signing-key-pkcs8.pub': _base64_string(f'{output_dir}/irsa-pkcs8.pub'),
    }, jwks_settings_json


if __name__ == "__main__":
    secret, jwks_json = create_jwks('/tmp/jwks')
    print(secret)
    print(jwks_json)
