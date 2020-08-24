from os import makedirs, environ
from uuid import uuid4
from base64 import b64encode

import gnupg


def create_key():
    gpg_home = '/tmp/.gnupg'
    makedirs(gpg_home, mode=0o700, exist_ok=True)

    gpg = gnupg.GPG(gnupghome=gpg_home, verbose=True)
    gpg.encoding = 'utf-8'
    
    # Allow for pipe passphrase delivery
    with open(f'{gpg_home}/gpg-agent.conf', 'w') as agent_config:
        agent_config.write('allow-loopback-pinentry\n')

    email = environ["EMAIL"]
    key_passphrase = str(uuid4())

    environ["GNUPGHOME"] = gpg_home
    input_data = gpg.gen_key_input(name_real='s3apt',
        name_comment='s3apt-indexer',
        name_email=email, 
        passphrase=key_passphrase, 
        key_type="RSA", 
        key_length=2048)
    key = gpg.gen_key(input_data)
    print(key.fingerprint)

    ascii_armored_public_keys = gpg.export_keys(key.fingerprint, False)
    ascii_armored_private_keys = gpg.export_keys(key.fingerprint, True, passphrase=key_passphrase)

    print(ascii_armored_public_keys)
    
    return {
        "key-id": key.fingerprint,
        "key-passphrase": key_passphrase,
        "public-key": b64encode(ascii_armored_public_keys.encode('ascii')).decode(),
        "private-key": b64encode(ascii_armored_private_keys.encode('ascii')).decode(),
    }, ascii_armored_public_keys


if __name__ == "__main__":
    print(create_key())
