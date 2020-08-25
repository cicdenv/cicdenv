from os import environ
from datetime import datetime, timezone

import boto3

from checksums import content_checksums
from gpg import gpg_init, key_init, sign_content


def rebuild_release_files(prefix, package_index_bytes):
    print("REBUILDING RELEASE FILE: %s/Release" % (prefix))

    s3 = boto3.resource('s3')
    release_file_obj = s3.Object(bucket_name=environ['BUCKET'], key=prefix + "/Release")

    print("Writing release file: %s" % (str(release_file_obj)))
    md5, sha1, sha256 = content_checksums(package_index_bytes)
    size = len(package_index_bytes)
    # Sat, 08 Feb 2020 22:07:37 UTC
    tstamp = datetime.now(tz=timezone.utc).strftime("%a, %d %b %Y %H:%M:%S %z")
    release = f"""\
Origin: Ubuntu
Label: Ubuntu
Version: 20.04
Codename: repo/dists/
Date: {tstamp}
Description: Ubuntu 20.04 LTS (Focal Fossa) cicdenv
MD5Sum:
 {md5} {size} Packages
SHA1:
 {sha1} {size} Packages
SHA256:
 {sha256} {size} Packages
"""
    print(release)
    release_file_obj.put(Body=release)

    print("DONE REBUILDING RELEASE FILE")

    print("REBUILDING IN-RELEASE FILE: %s/InRelease" % (prefix))
    
    gpg_init()
    key_id, passphrase = key_init()
    in_release = sign_content(release, key_id=key_id, passphrase=passphrase)
    print(in_release)

    in_release_file_obj = s3.Object(bucket_name=environ['BUCKET'], key=prefix + "/InRelease")
    in_release_file_obj.put(Body=str(in_release))

    print("DONE REBUILDING IN-RELEASE FILE")


if __name__ == "__main__":
    s3 = boto3.resource('s3')
    packages_file_obj = s3.Object(bucket_name=environ['BUCKET'], key="repo/dists/Packages")
    package_index_bytes = packages_file_obj.get()['Body'].read()

    rebuild_release_files('repo/dists', package_index_bytes)
