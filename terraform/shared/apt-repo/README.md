## Purpose
S3 backed debian/ubuntu apt repo.

NOTE: the indexer lives in [terraform/shared/apt-repo/indexer](./indexer)

![Shaun Zinck - s3apt](https://webscale.plumbing/images/lambda-apt-repo.png)

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
cloudwatch_log_groups = {
  "gpg" = {
    "arn" = "arn:aws:logs:<region>:<main-acct-id>:log-group:/aws/lambda/s3apt-gpg"
    "name" = "/aws/lambda/s3apt-gpg"
  }
  "indexer" = {
    "arn" = "arn:aws:logs:<region>:<main-acct-id>:log-group:/aws/lambda/s3apt-indexer"
    "name" = "/aws/lambda/s3apt-indexer"
  }
}
iam = {
  "gpg" = {
    "policy" = {
      "arn" = "arn:aws:iam::<main-acct-id>:policy/S3AptRepoGpgSecretLambda"
      "name" = "S3AptRepoGpgSecretLambda"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<main-acct-id>:role/s3apt-gpg"
      "name" = "s3apt-gpg"
    }
  }
  "indexer" = {
    "policy" = {
      "arn" = "arn:aws:iam::<main-acct-id>:policy/S3AptIndexer"
      "name" = "S3AptIndexer"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<main-acct-id>:role/s3apt-indexer"
      "name" = "s3apt-indexer"
    }
  }
}
lambdas = {
  "gpg" = {
    "function_name" = "s3apt-gpg"
    "handler" = "lambda.lambda_handler"
    "runtime" = "python3.8"
  }
  "indexer" = {
    "function_name" = "s3apt-indexer"
    "handler" = "lambda.lambda_handler"
    "runtime" = "python3.8"
  }
}
secrets = {
  "s3apt" = {
    "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:apt-repo-gpg-KoMFvc"
    "name" = "apt-repo-indexer"
  }
}
```

## Manual Install
```bash
cp <apt-transport-s3.py> /usr/lib/apt/methods/s3
chmod +x /usr/lib/apt/methods/s3
echo 'deb [trusted=yes] s3://apt-repo-cicdenv-com/ repo/dists/' > /etc/apt/sources.list.d/s3-repos.list
```

## Repo Structure
```
s3://apt-repo-cicdenv-com/repo/dists/
|-- *.deb
|-- key.asc      ← gpg key signing the repository and packages
|-- Packages     ← description of repo's packages
|-- InRelease    ← "in-file-signed" Release file (see below)
|-- Release      ← metadata (file listing and checksum) of the current repo
```

## GPG
Note: instances on start should check / install the package signing key.

```bash
curl -sL https://apt-repo-cicdenv-com.s3-us-west-2.amazonaws.com/repo/dists/key.asc
```

## Links
* https://medium.com/sqooba/create-your-own-custom-and-authenticated-apt-repository-1e4a4cf0b864
* https://webscale.plumbing/managing-apt-repos-in-s3-using-lambda
  * https://news.ycombinator.com/item?id=12241998
  * https://github.com/szinck/s3apt
* http://www.bauser.com/websnob/keydist
* https://packages.ubuntu.com/search?keywords=apt-transport-s3
  * https://github.com/MayaraCloud/apt-transport-s3
* http://www.fifi.org/doc/libapt-pkg-doc/method.html/ch2.html
* https://wiki.debian.org/RepositoryFormat
* http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/focal/
  * http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/focal/InRelease
  * http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/focal/main/binary-amd64/Packages
  * http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/focal/main/binary-amd64/
