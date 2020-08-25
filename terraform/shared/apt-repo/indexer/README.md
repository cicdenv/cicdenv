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

Creates:
* [s3://apt-repo-cicdenv-com/repo/dists/Packages](https://apt-repo-cicdenv-com.s3-us-west-2.amazonaws.com/repo/dists/Packages)
* [s3://apt-repo-cicdenv-com/repo/dists/Release](https://apt-repo-cicdenv-com.s3-us-west-2.amazonaws.com/repo/dists/Release)
* [s3://apt-repo-cicdenv-com/repo/dists/Release.gpg](https://apt-repo-cicdenv-com.s3-us-west-2.amazonaws.com/repo/dists/Release.gpg)
* [s3://apt-repo-cicdenv-com/repo/dists/InRelease](https://apt-repo-cicdenv-com.s3-us-west-2.amazonaws.com/repo/dists/InRelease)

## Update Workflow
```
cicdenv$ (cd terraform/shared/apt-repo/indexer; make lambda.zip)

📦 $USER:~/cicdenv$ (cd terraform/shared/apt-repo/indexer; make upload)

cicdenv$ cicdctl terraform apply shared/apt-repo:main -auto-approve

# Test in Lambda UI using a the faux event in ./samples/put-event.json
```

## Code
```
lambda.py
  lambda_handler

checksums.py
  content_checksums
  file_checksums
  calc_package_index_hash

control.py
  get_control_data
  read_control_data
  get_cached_control_data

package.py
  format_package_record
  get_package_index_hash
  rebuild_package_index

release.py
  rebuild_release_files

secrets.py
  get_secrets

gpg.py
  key_init
  sign_content
```

## Debugging
```
cicdenv$ ar -t terraform/shared/apt-packages/libnss-iam/libnss-iam-0.1.deb 
debian-binary
control.tar.xz
data.tar.xz

s3://apt-repo-cicdenv-com/repo/dists/libnss-iam-0.1.deb
```

## Timestamps
```
$ python -c 'from datetime import datetime, timezone; print(datetime.now(tz=timezone.utc).strftime("%a, %d %b %Y %H:%M:%S %z"))'
Sat, 08 Feb 2020 22:07:37 +0000

$ date --rfc-2822 --utc
Sat, 22 Aug 2020 18:48:08 +0000
```

## Inspiration
* https://github.com/szinck/s3apt
* http://webscale.plumbing/managing-apt-repos-in-s3-using-lambda

## Testing
```bash
cicdenv$ (cd terraform/shared/apt-repo/indexer; make test-*)
```

## Based On
* https://webscale.plumbing/managing-apt-repos-in-s3-using-lambda
  * https://github.com/szinck/s3apt
  * https://news.ycombinator.com/item?id=12241998

## Links
* https://medium.com/sqooba/create-your-own-custom-and-authenticated-apt-repository-1e4a4cf0b864
* https://pypi.org/project/python-debian/
  * https://salsa.debian.org/python-debian-team/python-debian/-/tree/master/examples/debfile
* https://gnupg.readthedocs.io/en/latest/
* https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#object
* https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Object.put
* https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
* https://packages.ubuntu.com/search?keywords=apt-transport-s3
  * https://github.com/MayaraCloud/apt-transport-s3
* http://www.fifi.org/doc/libapt-pkg-doc/method.html/ch2.html
* https://wiki.debian.org/RepositoryFormat
* http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/focal/
  * http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/focal/InRelease
  * http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/focal/main/binary-amd64/Packages
  * http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/focal/main/binary-amd64/
