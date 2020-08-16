## Purpose
Common resources for all KOPS kubernetes clusters in the same region/account.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy|output> kops/shared:${WORKSPACE}
...
```

## Open ID Connect Identity Provider Testing
Both the config and jwks files should be "public" readable.
The bucket is private with object level "public read" ACLs on these files.

Check `https://oidc-irsa-${WORKSPACE}-cicdenv-com.s3.amazonaws.com/jwks.json` (JSON Web Key Source) file:
```
curl -v -sL https://oidc-irsa-${WORKSPACE}-cicdenv-com.s3.amazonaws.com/jwks.json

> GET /jwks.json HTTP/1.1
> Host: oidc-irsa-${WORKSPACE}-cicdenv-com.s3.amazonaws.com
> User-Agent: curl/7.47.0
> Accept: */*
> 
< HTTP/1.1 200 OK
...
< Content-Type: application/json
...
* Connection #0 to host oidc-irsa-${WORKSPACE}-cicdenv-com.s3.amazonaws.com left intact
{
  "keys": [
    {
      "use": "sig",
      "kty": "RSA",
      "kid": "2Am2CglResHK0Hg6RSmWBABgXn9ZwdHKRmhXEEz2I5s",
      "alg": "RS256",
      "n": "...",
      "e": "AQAB"
    },
    {
      "use": "sig",
      "kty": "RSA",
      "kid": "",
      "alg": "RS256",
      "n": "...",
      "e": "AQAB"
    }
  ]
}
```

Check https://oidc-irsa-${WORKSPACE}-cicdenv-com.s3.amazonaws.com/.well-known/openid-configuration file:
```
curl -v -sL https://oidc-irsa-${WORKSPACE}-cicdenv-com.s3.amazonaws.com/.well-known/openid-configuration

> GET /.well-known/openid-configuration HTTP/1.1
> Host: oidc-irsa-${WORKSPACE}-cicdenv-com.s3.amazonaws.com
> User-Agent: curl/7.47.0
> Accept: */*
> 
< HTTP/1.1 200 OK
...
< Content-Type: application/json
...
{
  "issuer": "https://oidc-irsa-${WORKSPACE}-cicdenv-com.s3.amazonaws.com/",
  "jwks_uri": "https://oidc-irsa-${WORKSPACE}-cicdenv-com.s3.amazonaws.com/jwks.json",
  "authorization_endpoint": "urn:kubernetes:programmatic_authorization",
  "response_types_supported": [
    "id_token"
  ],
  "subject_types_supported": [
    "public"
  ],
  "id_token_signing_alg_values_supported": [
    "RS256"
  ],
  "claims_supported": [
    "sub",
    "iss"
  ]
}
```

## Importing
```hcl
data "terraform_remote_state" "kops_shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
etcd_kms_key = {
  "arn" = "arn:aws:kms:us-west-2:<account-id>:key/<guid>"
  "key_id" = "<guid>"
  "name" = "alias/kops-etcd"
}
security_groups = {
  "external_apiserver" = {
    "id" = "sg-<0x*17>"
  }
  "internal_apiserver" = {
    "id" = "sg-<0x*17>"
  }
  "master" = {
    "id" = "sg-<0x*17>"
  }
  "node" = {
    "id" = "sg-<0x*17>"
  }
}
irsa = {
  "cluster_spec" = {
    "kubeAPIServer" = "apiAudiences:\n- sts.amazonaws.com\nserviceAccountIssuer: https://oidc-irsa-<domain->.s3.amazonaws.com\nserviceAccountKeyFile:\n- /srv/kubernetes/server.key\n- /srv/kubernetes/assets/service-account-key\nserviceAccountSigningKeyFile: /srv/kubernetes/assets/service-account-signing-key\n"
  }
  "oidc" = {
    "iam" = {
      "oidc_provider" = {
        "arn" = "arn:aws:iam::<main-acct-id>:oidc-provider/oidc-irsa-<workspace>-<domain->.s3.amazonaws.com"
        "client_id_list" = [
          "sts.amazonaws.com",
        ]
        "thumbprint_list" = [
          "a9d53002e97e00e043244f3d170d6f4c414104fd",
        ]
        "url" = "oidc-irsa-<workspace>-<domain->.s3.amazonaws.com"
      }
    }
    "s3" = {
      "oidc_issuer" = {
        "bucket_domain_name" = "oidc-irsa-<workspace>-<domain->.s3.amazonaws.com"
        "bucket_name" = "oidc-irsa-<workspace>-<domain->"
      }
    }
  }
}
```
