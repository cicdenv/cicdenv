#
# Python alternative to shell+openssl method of obtaining 
# root ca sha1 fingerprint
#
# https://github.com/hashicorp/terraform-provider-tls/issues/52
# https://www.terraform.io/docs/providers/external/data_source.html
# https://www.solrac.nl/retrieve-thumbprint-ssltls-python/
# 

from sys import stdin
import json

import ssl
import socket
import hashlib

query = json.load(stdin)
address = query["uri"]

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.settimeout(1)

with ssl.wrap_socket(sock) as ssl_sock:
    ssl_sock.connect((address, 443))
    der_cert_bin = ssl_sock.getpeercert(True)
    pem_cert = ssl.DER_cert_to_PEM_cert(ssl_sock.getpeercert(True))

    # SHA1 Thumbprint
    thumb_sha1 = hashlib.sha1(der_cert_bin).hexdigest()

    result = {
      "sha1": thumb_sha1,
    }
    print(json.dumps(result))
