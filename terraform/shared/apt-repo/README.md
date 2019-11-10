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

## Links
* https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html
* https://packages.ubuntu.com/search?keywords=apt-transport-s3
