from sys import stdout, stderr
from subprocess import check_call
from os import path, remove

from base64 import b64encode


def _string(file):
    return open(file).read().strip()


def create_keypair():
    # Create a wireguard keypair
    wg_cmds = 'umask 077; wg genkey > /tmp/wireguard.key; wg pubkey < /tmp/wireguard.key > /tmp/wireguard.pub'
    check_call(args=wg_cmds, shell=True, stdin=None, stdout=stdout, stderr=stderr)

    # Return
    return {
        'private.key': _string('/tmp/wireguard.key'),
        'public.key': _string('/tmp/wireguard.pub'),
    }


if __name__ == "__main__":
    print(create_keypair())
