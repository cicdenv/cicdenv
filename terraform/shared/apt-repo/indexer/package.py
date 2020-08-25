from os import environ

import boto3
import botocore

from checksums import calc_package_index_hash
from control import get_cached_control_data


def get_package_index_hash(prefix):
    """
    Returns the md5 hash of the names of all the packages in the index. This can be used
    to detect if all the packages are represented without having to load a control data cache
    file for each package.
    """
    s3 = boto3.resource('s3')
    try:
        print("looking for existing Packages file: %sPackages" % prefix)
        package_index_obj = s3.Object(bucket_name=environ['BUCKET'], key=prefix + 'Packages')
        return package_index_obj.metadata.get('packages-hash', None)
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == '404':
            return None
        else:
            raise(e)


def rebuild_package_index(prefix):
    # Get all .deb keys in directory
    # Get the cache entry
    # build package file
    deb_names = []
    deb_objs = []

    filter_prefix = prefix + '/'

    print("REBUILDING PACKAGE INDEX: %s" % (prefix))
    s3 = boto3.resource('s3')
    for obj in s3.Bucket(environ['BUCKET']).objects.filter(Prefix=filter_prefix):
        if not obj.key.endswith(".deb"):
            continue
        deb_objs.append(obj)
        deb_names.append(obj.key.split('/')[-1])

    if not len(deb_objs):
        print("NOT BUILDING EMPTY PACKAGE INDEX")
        return

    # See if we need to rebuild the package index
    metadata_pkghash = get_package_index_hash(filter_prefix)
    calcd_pkghash = calc_package_index_hash(deb_names)
    print("calcd_pkghash=%s, metadata_pkghash=%s" % (calcd_pkghash, metadata_pkghash))

    pkginfos = []
    for obj in deb_objs:
        print(obj.key)

        pkginfo = get_cached_control_data(obj)
        pkginfo = pkginfo.decode('utf-8') + "\n%s\n" % ("Filename: %s" % obj.key)
        pkginfos.append(pkginfo)

    package_index_obj = s3.Object(bucket_name=environ['BUCKET'], key=prefix + "/Packages")
    print("Writing package index: %s" % (str(package_index_obj)))
    package_index = "\n".join(sorted(pkginfos))
    package_index_bytes = package_index.encode('utf-8')
    package_index_obj.put(Body=package_index_bytes, Metadata={'packages-hash': calcd_pkghash}, ContentType="text/plain")
    print("DONE REBUILDING PACKAGE INDEX")

    return package_index_bytes


if __name__ == "__main__":
    get_package_index_hash('repo/dists/')
    rebuild_package_index('repo/dists')
