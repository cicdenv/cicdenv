## Purpose
Generates an OpenPGP (GNU gpg v2.1) package signing key pgp key pair.

Secret Keys:
```
key-id	        6233CB772C58916A874A2E8B458AD13A41580D16
key-passphrase	
public-key
private-key
```

## View Current
```bash
📦 $USER:~/cicdenv$ (AWS_PROFILE=admin-main aws --region=us-west-2 s3 cp s3://apt-repo-cicdenv-com/repo/dists/key.asc -
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.22 (GNU/Linux)

mQENBF9ERf4BCADD2wUprX/XHAOgsVpIdrEklZiguStKiYv5TccyuCmaVsfGbktb
H13uEPnCoRpOH8GlQwjO3tR3NXVuC7mSN9msfBv0V8r+vijpaRxn0/GU1dRvJqGO
+/PN+kcJCyXonZ0yLj4zb7bWVK4X3jnPPdgdhp2zKUYlxZT3kBeOhImD+qa+gs0A
73SudynQ558sH7hbCfnqDFQGz6ntO3GlcnBP0FSAMYAfahRHY5qFdgBAFgWTTjrq
rnT2LqXY88InG2RkcpCKfTkprY89DGV1mFvbzjdfGepx6JzgkuLXCV3T8t9PUdDk
LtVqmL8BbdQS5ElzPAFCIlN3N6o2QVd3YKPJABEBAAG0OHMzYXB0IChzM2FwdC1p
bmRleGVyKSA8ZnJlZC52b2d0K2FwdC1yZXBvLWdwZ0BnbWFpbC5jb20+iQE5BBMB
AgAjBQJfREX+AhsvBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQEGA7rf9f
skja/QgAgu7IPGAzm7AY6v4ugv//xbzByS5HgKgRxIhi3bFVwxYZMSAKrsbM9aWW
4Fzl1ezb4BKr5lP/KwuplSl3H8+QC1mKRCrPziL+Dd51avsy+i+NaelFhCrLEH22
DyhS2rdpQy5glX6BiULB6SnU24Y4U9EK+egXRkakcoHxY19kxO8ADaUyVJM9DXNK
s+xbNIfTrOHaEkOhMfmdD59ETxp408I5MKR838DbLyXxMIgtrYPXjoVWluHTRn1Z
20Mwzfk/JUkbU4XPy+Ig02XErXRCxs+BFq6nuXP3/4+GNVSxTmc0dLiamFd/UvOu
L5EBsHIC3WTsyyYZGxHbweVdAC/FCA==
=ggAk
-----END PGP PUBLIC KEY BLOCK-----
```

## Testing
```bash
cicdenv$ (cd terraform/shared/apt-repo/gpg-keys; make test-*)
```

## Entropy
```
[GNUPG:] PROGRESS need_entropy X 20 300

sudo apt-get install -y haveged
sudo apt-get install -y rng-tools

cat /proc/sys/kernel/random/entropy_avail
```

## Links
* https://www.saltycrane.com/blog/2011/10/python-gnupg-gpg-example/
* https://gnupg.readthedocs.io/en/latest/
* https://gist.github.com/ryantuck/56c5aaa8f9124422ac964629f4c8deb0
* https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
* https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html
* https://gist.github.com/tknv/43604e851a371949343b78261c48f190
* https://www.reddit.com/r/GnuPG/comments/7qi6os/show_me_your_gpgconf_gpgagentconf/

* https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#object
* https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Object.put
* https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
  * http://www.bauser.com/websnob/keydist
