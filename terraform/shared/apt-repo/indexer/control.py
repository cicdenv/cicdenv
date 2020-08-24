from os import environ, fdopen, stat, remove
import re

import boto3
import botocore

import debian.arfile
import tarfile
import tempfile

from checksums import file_checksums


def format_package_record(ctrl, fname):
    pkgrec = ctrl.strip().split("\n")

    fstat = stat(fname)
    pkgrec.append("Size: %d" % (fstat.st_size))

    md5, sha1, sha256 = file_checksums(fname)
    pkgrec.append("MD5sum: %s" % (md5))
    pkgrec.append("SHA1: %s" % (sha1))
    pkgrec.append("SHA256: %s" % (sha256))

    return "\n".join(pkgrec)


def get_control_data(debfile):
    ar = debian.arfile.ArFile(debfile)

    entry_names = ar.getnames()
    if 'control.tar.xz' in entry_names:
        control_fh = ar.getmember('control.tar.xz')
        tar_file = tarfile.open(fileobj=control_fh, mode='r:xz')
    elif 'control.tar.gz' in entry_names:
        control_fh = ar.getmember('control.tar.gz')
        tar_file = tarfile.open(fileobj=control_fh, mode='r:gz')
    else:
        print("Could not find 'control.tar.<xz|gz>'.  Entries:")
        print("\n".join(entry_names))
        raise KeyError("Could not find 'control.tar.<xz|gz>'")

    # control file can be named different things
    control_file_name = [x for x in tar_file.getmembers() if x.name in ['control', './control']][0]

    control_data = tar_file.extractfile(control_file_name).read().strip()
    # Strip out control fields with blank values.  
    # This tries to allow folded and multiline fields to pass through.
    # See the debian policy manual for more info on folded and multiline fields.
    # https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-binarycontrolfiles
    lines = control_data.decode('utf-8').strip().split("\n")
    filtered = []
    for line in lines:
        # see if simple field
        if re.search(r"^\w[\w\d_-]+\s*:", line):
            k, v = line.split(':', 1)
            if v.strip() != "":
                filtered.append(line)
        else:
            # otherwise folded or multiline, just pass it through
            filtered.append(line)

    return "\n".join(filtered)


def read_control_data(deb_obj):
    """
    Downloads the .deb file and reads the debian control data out of it.
    This also adds in packaging data (md5, sha, etc) that is not in control
    files.
    """
    print("Creating cached control data for: %s" % (str(deb_obj)))

    fd, tmp = tempfile.mkstemp()
    with fdopen(fd, "wb") as fh:
        s3fh = deb_obj.get()['Body']
        size = 1024 * 1024
        while True:
            dat = s3fh.read(size)
            fh.write(dat)
            if len(dat) < size:
                break

    try:
        ctrl = get_control_data(tmp)
        pkg_rec = format_package_record(ctrl, tmp)
        return pkg_rec
    finally:
        remove(tmp)


def get_cached_control_data(deb_obj):
    """
    Get cached control file information about a debian package, or build it if
    this is the first time.
    """
    s3 = boto3.resource('s3')
    etag = deb_obj.e_tag.strip('"')

    cache_obj = s3.Object(bucket_name=environ['BUCKET'], key=environ['CACHE_PREFIX'] + '/' + etag)
    exists = True
    try:
        control_data = cache_obj.get()['Body'].read()
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == 'NoSuchKey':
            exists = False
        else:
            raise(e)

    if not exists:
        control_data = read_control_data(deb_obj)
        cache_obj.put(Body=control_data)

    return control_data


if __name__ == "__main__":
    get_control_data('/tmp/libnss-iam-0.1.deb')

    s3 = boto3.resource('s3')
    deb_obj = s3.Object(bucket_name=environ['BUCKET'], key='repo/dists/libnss-iam-0.1.deb')

    read_control_data(deb_obj)
    get_cached_control_data(deb_obj)
