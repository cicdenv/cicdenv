## Purpose
S3 backed debian/ubuntu apt repo.

NOTE: the indexer lives in [terraform/shared/apt-repo-indexer](../apt-repo-indexer)

## Workspaces
N/A.

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy> shared/apt-repo:main
...
```

## Manual Install
```
cp <apt-transport-s3.py> /usr/lib/apt/methods/s3
chmod +x /usr/lib/apt/methods/s3
echo 'deb [trusted=yes] s3://apt-repo-cicdenv-com/ repo/dists/' > /etc/apt/sources.list.d/s3-repos.list
```

## Links
* https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html
* https://packages.ubuntu.com/search?keywords=apt-transport-s3
