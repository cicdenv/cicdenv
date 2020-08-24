import hashlib


def content_checksums(content):
    md5 = hashlib.md5()
    sha1 = hashlib.sha1()
    sha256 = hashlib.sha256()

    md5.update(content)
    sha1.update(content)
    sha256.update(content)

    return md5.hexdigest(), sha1.hexdigest(), sha256.hexdigest()


def file_checksums(fname):
    with open(fname, "rb") as f:
        md5 = hashlib.md5()
        sha1 = hashlib.sha1()
        sha256 = hashlib.sha256()
        
        size = 1024 * 1024
        while True:
            dat = f.read(size)
            md5.update(dat)
            sha1.update(dat)
            sha256.update(dat)
            if len(dat) < size:
                break

    return md5.hexdigest(), sha1.hexdigest(), sha256.hexdigest()


def calc_package_index_hash(deb_names):
    """
    Calculates a hash of all the given deb file names. This is deterministic so
    we can use it for short-circuiting.
    """
    md5 = hashlib.md5()
    md5.update("\n".join(sorted(deb_names)).encode('utf-8'))
    return md5.hexdigest()


if __name__ == "__main__":
    print(content_checksums('test'.encode()))
    
    with open('/tmp/test.txt', 'wb') as f:
        f.write('test'.encode())
    print(file_checksums('/tmp/test.txt'))
    
    print(calc_package_index_hash(['package-2.deb', 'package-1.deb']))
