from sys import stdout, stderr
from subprocess import check_call
from os import path, remove

from base64 import b64encode

from cryptography.hazmat.primitives.serialization import Encoding, PublicFormat, PrivateFormat, NoEncryption
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.backends import default_backend

PUBLIC_EXPONENT = 65537
KEY_SIZE = 2048


def _base64_string(bytes):
    return b64encode(bytes).decode()


def create_key():
    # Create RSA TLS keypair
    key = rsa.generate_private_key(backend=default_backend(), public_exponent=PUBLIC_EXPONENT, key_size=KEY_SIZE)

    # get private key in PEM container format
    key_pem = key.private_bytes(encoding=Encoding.PEM, format=PrivateFormat.TraditionalOpenSSL, encryption_algorithm=NoEncryption())

    # get public key in OpenSSH format
    public_key = key.public_key().public_bytes(Encoding.OpenSSH, PublicFormat.OpenSSH)

    # Return
    return {
        'private-key': _base64_string(key_pem),
        'public-key': _base64_string(public_key),
    }


if __name__ == "__main__":
    print(create_key())
