## Purpose
Host Private Ubuntu Repos in an AWS S3 bucket.

This code watches S3 buckets for changes, and rebuilds the debian package index
and (signed) release file(s) whenever something changes.
It is the cloud equivalent of:
* [dpkg-scanpackages](https://manpages.debian.org/testing/dpkg-dev/dpkg-scanpackages.1.en.html) - with signing.

There are multiple parts:
1. s3 bucket
1. lambda gnupg2 key generator (secret rotator) for AWS secrets manager
1. lambda apt repo indexer / re-indexer
1. host apt-get configuration

## Inspiration
* https://github.com/szinck/s3apt
* http://webscale.plumbing/managing-apt-repos-in-s3-using-lambda

## Testing
```bash
cicdenv$ (cd terraform/shared/apt-repo/indexer; make test-*)
```
