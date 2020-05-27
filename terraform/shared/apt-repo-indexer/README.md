## Purpose
S3 backed debian/ubuntu apt repo lambda indexer.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/apt-repo-lambda:main
...
```

## Importing
N/A.

## Outputs
```hcl
cloudwatch_log_groups = {
  "s3apt" = {
    "arn" = "arn:aws:logs:<region>:<main-acct-id>:log-group:/aws/lambda/s3apt:*"
    "name" = "/aws/lambda/s3apt"
  }
}
iam = {
  "s3apt" = {
    "policy" = {
      "arn" = "arn:aws:iam::<main-acct-id>:policy/s3apt"
      "name" = "s3apt"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<main-acct-id>:role/s3apt"
      "name" = "s3apt"
    }
  }
}
lambdas = {
  "s3apt" = {
    "function_name" = "s3apt"
    "handler" = "s3apt.lambda_handler"
    "runtime" = "python3.7"
  }
}
secrets = {
  "s3apt" = {
    "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:apt-repo-indexer-KoMFvc"
    "name" = "apt-repo-indexer"
  }
}
```

## Testing
Local:
```bash
# Copy a .deb file into a cicdenv container
#  NOTE: if you're running multiple cicdenv sessions:
#        `cat /proc/self/cgroup` to get the right container-id
docker cp ~/personal/dev/libnss-iam/libnss-iam-0.1.deb \
          <cicdenv container-id>:/home/$USER/cicdenv/terraform/shared/apt-repo-indexer/s3apt

# From cicdenv shell
📦 ${USER}:~/cicdenv/terraform/shared/apt-repo-indexer/s3apt$ make test
source .venv/bin/activate; python s3apt.py *.deb
Package: libnss-iam 
Version: 0.1 
Architecture: amd64 
Maintainer: George Fleury <gfleury@gmail.com> 
Homepage: https://github.com/gfleury/libnss-iam 
Description: Lib NSS module to integrate IAM users/groups
Size: 8598338
MD5sum: 677e6ce7bafc2ab9e74552fa6ebde81e
SHA1: 60718fd8c158c945e5b59ce7f133bf0860770e67
SHA256: 2af37af1a8fd243f2cfb28e57ed9f6f5d549a7c5c8bef5a46567c6bc2f091e4d
```

Uploading .deb(s):
```bash
# Uploads any debs in the s3apt/ folder
${USER}:~/cicdenv/terraform/shared/apt-repo-indexer/s3apt$ make upload
```

Lambda updates:
```bash
# Upload new code to S3
cicdenv/terraform/shared/apt-repo-indexer/s3apt$ make publish

# Re-apply terraform state to use the new version
cicdenv$ cicdctl terraform apply shared/apt-repo-indexer:main -auto-approve

# Test in Lambda UI using a the faux event in test/put-event.json
```

Host:
```bash
# Verify the s3 method is working and deps are met
$ cat <<'EOF' | /usr/lib/apt/methods/s3
600 URI Acquire
URI:s3://apt-repo-cicdenv-com/repo/dists/Packages
Filename:Packages.downloaded
Fail-Ignore:true
Index-File:true

EOF

# Verify host has s3 access
$ aws --region=<region> s3 ls s3://apt-repo-cicdenv-com/repo/dists/

# Install a package
$ sudo apt update && sudo apt install libnss-iam
```

## Links
* https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  * https://stackoverflow.com/questions/58754027/gpg-aws-serverless
  * https://forums.aws.amazon.com/thread.jspa?threadID=307497
  * https://help.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key
  * http://www.webupd8.org/2010/01/how-to-create-your-own-gpg-key.html
* https://webscale.plumbing/managing-apt-repos-in-s3-using-lambda
  * https://news.ycombinator.com/item?id=12241998
  * https://github.com/szinck/s3apt
* https://docs.aws.amazon.com/lambda/latest/dg/lambda-python-how-to-create-deployment-package.html
* https://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html#notification-how-to-event-types-and-destinations
* https://github.com/MayaraCloud/apt-transport-s3
* https://github.com/google/apt-golang-s3
* http://www.fifi.org/doc/libapt-pkg-doc/method.html/ch2.html
* https://wiki.debian.org/RepositoryFormat
* http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/bionic/
* http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/bionic/InRelease
* http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/bionic/main/binary-amd64/Packages
* http://us-west-2.ec2.archive.ubuntu.com/ubuntu/dists/bionic/main/binary-amd64/
* https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
