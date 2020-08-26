## Purpose
Enables debian/ubuntu apt packer to access our s3 hosted apt repo.

* https://apt-repo-cicdenv-com.s3-us-west-2.amazonaws.com/repo/dists/key.asc
  ```bash
  curl -sL https://apt-repo-cicdenv-com.s3-us-west-2.amazonaws.com/repo/dists/key.asc | apt-key add -
  ```

## Links
* https://github.com/MayaraCloud/apt-transport-s3

### Issues
* [`iamrole` attribute should be a string (unfixed upstream)](https://github.com/MayaraCloud/apt-transport-s3/pull/50)
* [IMDSv2 support](https://github.com/MayaraCloud/apt-transport-s3/pull/54)

## Debugging
```bash
root@...:~# cat /etc/apt/sources.list.d/s3-repos.list 
deb s3://apt-repo-cicdenv-com/ repo/dists/

root@...:~# apt-key list
/etc/apt/trusted.gpg
--------------------
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]

pub   rsa2048 2020-08-25 [SCEA]
      8659 F148 0815 8A02 A946  890E 7A9C E865 D418 F092
uid           [ unknown] s3apt (s3apt-indexer) <fred.vogt+apt-repo-gpg@gmail.com>

root@...:~# apt-key del 8659F14808158A02A946890E7A9CE865D418F092

$ gpg --version
gpg (GnuPG) 1.4.20
Copyright (C) 2015 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

SHA512
Home: ~/.gnupg
Supported algorithms:
Pubkey: RSA, RSA-E, RSA-S, ELG-E, DSA
Cipher: IDEA, 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH,
        CAMELLIA128, CAMELLIA192, CAMELLIA256
Hash: MD5, SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
Compression: Uncompressed, ZIP, ZLIB, BZIP2

# Verify the s3 method is working and deps are met
$ cat <<'EOF' | /usr/lib/apt/methods/s3
600 URI Acquire
URI:s3://apt-repo-cicdenv-com/repo/dists/Packages
Filename:Packages.downloaded
Fail-Ignore:true
Index-File:true

EOF

# Verify host has s3 access
$aws s3 cp s3://apt-repo-cicdenv-com/repo/dists/key.asc -

# Install a package
$ apt update && sudo apt install libnss-iam
```
