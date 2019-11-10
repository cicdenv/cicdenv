s3apt
=====

NOTE:
```
Slightly modified to work in our environment.
```

Host Private Ubuntu Repos in S3

This code watches S3 buckets for changes, and rebuilds the debian package index
whenever something changes.  It is the cloud equivalent of *dpkg-scanpackages*.

There are 2 parts to this: Lambda configuration and apt-get configuration

Lambda Quick Start
------------------

To get started, you need to configure your bucket name and upload the code as a
lambda.

Clone the repo.

```
git clone https://github.com/szinck/s3apt.git
cd s3apt
```

Configure your bucket name.

```
cp config.py.example config.py
vim config.py
# Edit the APT_REPO_BUCKET_NAME to be the name of the bucket (with no s3:// prefix)
```

Create a zip file of the code.

```
zip  code.zip s3apt.py config.py
(cd venv/lib/python2.7/site-packages/ ; zip -r ../../../../code.zip *)
```

Create a new lambda in the AWS Console, and upload the zip file.

Set the lambda handler as **s3apt.lambda_handler** and configure triggers as
below.

* Object Created (ALL), prefix=/dists/
* Object Removed (ALL), prefix=/dists/

Start uploading files to S3, and the lambda should keep everything in sync.

Apt-get configuration
---------------------

For details on apt-get configuration see
http://webscale.plumbing/managing-apt-repos-in-s3-using-lambda

Testing
-------

Setup

```
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt
```

Testing against your packages:

If you specify the name of the package on the command line you can cause the
code to generate a package index entry.

```
$ python s3apt.py elasticsearch-2.3.3.deb
Package: elasticsearch
Version: 2.3.3
Section: web
Priority: optional
Architecture: all
Depends: libc6, adduser
Installed-Size: 30062
Maintainer: Elasticsearch Team <info@elastic.co>
Description: Elasticsearch is a distributed RESTful search engine built for the cloud. Reference documentation can be found at https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html and the 'Elasticsearch: The Definitive Guide' book can be found at https://www.elastic.co/guide/en/elasticsearch/guide/current/index.html
Homepage: https://www.elastic.co/
Size: 27426588
MD5sum: e343866c166ca1ef69b9115d36deeae2
SHA1: 8385dda7aa3870a3b13fc1df91d8b750d940700e
SHA256: fa90c6aefc5e82e0e19cb0ec546b9a64fec354ede201cf24658ddcfe01762d92
```
