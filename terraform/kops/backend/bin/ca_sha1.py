#
# Python alternative to shell+openssl method of obtaining 
# root ca sha1 fingerprint
#
# https://github.com/hashicorp/terraform-provider-tls/issues/52
# https://www.terraform.io/docs/providers/external/data_source.html
#

from sys import stdin
import json
from contextlib import closing

import ssl
import socket
import hashlib

from OpenSSL import SSL
from OpenSSL.crypto import load_certificate, dump_certificate, FILETYPE_ASN1, FILETYPE_PEM

query = json.load(stdin)
address = query["uri"]

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.settimeout(1)

with closing(SSL.Connection(SSL.Context(method=SSL.TLSv1_METHOD), socket=sock)) as conn:
    conn.connect((address, 443))
    conn.setblocking(1)
    conn.do_handshake()

    root_CN = conn.get_peer_cert_chain()[-1].get_issuer().CN
    with open(f'/etc/ssl/certs/ca-cert-{root_CN.replace(" ", "_")}.pem') as f:
        root_cert = load_certificate(FILETYPE_PEM, f.read())
        root_cert_enc = dump_certificate(FILETYPE_ASN1, root_cert)

        # SHA1 Thumbprint
        thumb_sha1 = hashlib.sha1(root_cert_enc).hexdigest()

        result = {
          "sha1": thumb_sha1,
        }
        print(json.dumps(result))
