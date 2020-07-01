from sys import stdout, stderr
from subprocess import check_call
from os import path, remove

from base64 import b64encode


def _base64_string(file):
    return b64encode(open(file).read().encode()).decode()


def create_ca(prefix):
    # Create CA (cert+key)
    cfssl_cmd = f'cfssl gencert -initca -config=./ca-config.json ./ca-csr.json | cfssljson -bare {prefix}'
    check_call(args=cfssl_cmd, shell=True, stdin=None, stdout=stdout, stderr=stderr)

    # delete certificate signing request
    if path.isfile(f'{prefix}.csr'):
        remove(f'{prefix}.csr')

    # Return
    return {
        'cert': _base64_string(f'{prefix}.pem'),
        'key': _base64_string(f'{prefix}-key.pem'),
    }


if __name__ == "__main__":
    print(create_ca('/tmp/ca'))
