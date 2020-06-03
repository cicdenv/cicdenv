## Test Workflow
- delete cloudwatch logs
- delete s3 objects
- upload/terraform, re-upload `*.deb(s)`
  ```
  $ cicdctl console
  📦 $USER:~/cicdenv/terraform/shared/apt-repo-indexer/s3apt$ make publish && cicdctl terraform apply shared/apt-repo-indexer
  📦 $USER:~/cicdenv/terraform/shared/apt-repo-indexer/s3apt$ make upload
  ```

## GPG Key
Overview:
- settings
  - real name, email
  - passphrase
- generate key 
- update secret in AWS secrets manager
  - key-id
  - passphrase
  - public key base64 encoded PEM file
  - private key base64 encoded PEM file

### Create
```bash
$ gpg --gen-key
Real name: CI/CD Environment
Email address: fred.vogt+cicdenv@gmail.com
You selected this USER-ID:                
    "CI/CD Environment <fred.vogt+cicdenv@gmail.com>"
=> Enter passphrase

gpg: key 458AD13A41580D16 marked as ultimately trusted
gpg: revocation certificate stored as '/home/terraform/.gnupg/openpgp-revocs.d/6233CB772C58916A874A2E8B458AD13A41580D16.rev'
public and secret key created and signed.

pub   rsa2048 2020-02-09 [SC] [expires: 2022-02-08]
      6233CB772C58916A874A2E8B458AD13A41580D16
uid                      CI/CD Environment <fred.vogt+cicdenv@gmail.com>
sub   rsa2048 2020-02-09 [E] [expires: 2022-02-08]
```

Check:
```bash
$ gpg --list-keys
$ gpg --list-secret-keys --keyid-format LONG

# key-id
6233CB772C58916A874A2E8B458AD13A41580D16
```

### Export Keys
```bash
# public key
$ gpg --export --armor "fred.vogt+cicdenv@gmail.com" | base64

# private key
$ gpg --export-secret-key --armor "fred.vogt+cicdenv@gmail.com" | base64
```

### AWS Secrets Manager
```
apt-repo-indexer
  key-id
  key-passphrase
  public-key
  private-key
```
