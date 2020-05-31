## Purpose
IAM Roles for (Kubernetes) Service Accounts integration.

## One Time Setup
* [bin/irsa-create-key.sh]
* [bin/irsa-encrypt-key.sh]
* commit files ...
or:
* [bin/decrypt-key.sh]
* use files ...

## Terraform
Note - this implementation was not used - always results in dirty plans

The file `oidc-ca.sha1` and [bin/ca-sha1.sh] are not used either.

*.tf:
```hcl
resource "null_resource" "oidc_ca_sha1" {
  triggers = {
    command = <<EOF
echo                                                       \
| openssl s_client                                         \
  -servername "${aws_s3_bucket.oidc.bucket_domain_name}"   \
  -showcerts                                               \
  -connect "${aws_s3_bucket.oidc.bucket_domain_name}:443"  \
| openssl x509                                             \
  -fingerprint                                             \
  -noout                                                   \
| grep 'SHA1 Fingerprint='                                 \
| cut -d '=' -f 2                                          \
| sed -e 's/://g'                                          \
| tr 'A-Z' 'a-z'                                           \
> irsa/oidc-ca.sha1
EOF
  }

  provisioner "local-exec" {
    command = self.triggers.command
  }
}

data "local_file" "oidc_ca_sha1" {
  filename = "${path.module}/irsa/oidc-ca.sha1"

  depends_on = [
    null_resource.oidc_ca_sha1,
  ]
}

resource "aws_iam_openid_connect_provider" "irsa" {
  url = "https://${aws_s3_bucket.oidc.bucket_domain_name}"
  
  client_id_list = [
    "sts.amazonaws.com",
  ]
  
  thumbprint_list = [
    trimspace(data.local_file.oidc_ca_sha1.content),
  ]
}
```
