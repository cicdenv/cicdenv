from __future__ import print_function

import json
import urllib
import sys
from os import environ
import subprocess

import boto3

from release import rebuild_release_files
from package import rebuild_package_index
from control import get_cached_control_data


def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'])
    file = key.split('/')[-1]
    prefix = "/".join(key.split('/')[0:-1])

    # If a deb was uploaded
    if file.endswith(".deb") and event['Records'][0]['eventName'].startswith('ObjectCreated'):
        s3 = boto3.resource('s3')
        deb_obj = s3.Object(bucket_name=bucket, key=key)
        print("S3 Notification of new key. Ensuring cached control data exists: %s" % (str(deb_obj)))
        get_cached_control_data(deb_obj)

    # If a .deb was updated, added or deleted, rebuild the index.
    # If the Package index or *Release files were modified rebuild Package index and *Release files
    if bucket == environ['BUCKET'] and file.endswith(".deb") or file in ["Packages", "Release", "InRelease", "key.asc"]:
        package_index_bytes = rebuild_package_index(prefix)
        rebuild_release_files(prefix, package_index_bytes)

    print("DONE")


if __name__ == "__main__":
    lambda_handler({
        "Records": [{
            "eventName": "ObjectCreated:Put",
            "s3": {
                "bucket": {
                    "name": "apt-repo-cicdenv-com",
                },
                "object": {
                    "key": "repo/dists/libnss-iam-0.1.deb",
                }
            }
        }],
    }, None)
