## Purpose
S3 backed debian/ubuntu apt repo.

NOTE: the indexer lives in [terraform/shared/apt-repo-indexer](../apt-repo-indexer)

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/apt-repo:main
...
```

## Importing
```hcl
data "terraform_remote_state" "apt_repo" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_apt-repo/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
apt_repo_bucket = {
  "arn" = "arn:aws:s3:::apt-repo-<domain->"
  "id" = "apt-repo-<domain->"
}
```

## Manual Install
```bash
cp <apt-transport-s3.py> /usr/lib/apt/methods/s3
chmod +x /usr/lib/apt/methods/s3
echo 'deb [trusted=yes] s3://apt-repo-cicdenv-com/ repo/dists/' > /etc/apt/sources.list.d/s3-repos.list
```

## Links
* https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html
* https://packages.ubuntu.com/search?keywords=apt-transport-s3
