from os import makedirs
import base64

import gnupg

from secrets import get_secrets


gpg = None


def gpg_init():
    global gpg

    gpg_home = '/tmp/.gnupg'
    makedirs(gpg_home, mode=0o700, exist_ok=True)

    # Allow for pipe passphrase delivery
    with open(f'{gpg_home}/gpg-agent.conf', 'w') as agent_config:
        agent_config.write('allow-loopback-pinentry\n')

    gpg = gnupg.GPG(gnupghome=gpg_home, verbose=False)
    gpg.encoding = 'utf-8'
    print('SUCCESS - GPG INIT')


def key_init():
    global gpg

    # secrets
    key_id, passphrase, public_key, private_key = get_secrets()

    key_data = f'{public_key}\n{private_key}'

    # print(key_data)
    imported = gpg.import_keys(key_data)
    print(imported.fingerprints)

    return key_id, passphrase


def sign_content(content, key_id, passphrase):
    return gpg.sign(content, keyid=key_id, passphrase=passphrase)


if __name__ == "__main__":
    gpg_init()
    signed_content = sign_content('test', *key_init())
    print(signed_content)
