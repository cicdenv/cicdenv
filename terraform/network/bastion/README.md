## Purpose
Jump host(s) for KOPS VPCs.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy|output> kops/bastion:${WORKSPACE}
...
```

## SSH Key
`~/.ssh/manual-testing.pub`

## libnss_iam
Me and George are working on an official release.
Currently there is none.

Currently serving out of `s3://kops.cicdenv.com` because this authorizes by S3 VPC endpoint.

* Using a build from: https://github.com/vogtech/libnss-iam/tree/fred-01
* Follow the build instructions: https://github.com/gfleury/libnss-iam

Upload to s3:
```bash
libnss-iam$ AWS_OPTS="--profile=admin-main --region=us-west-2"
libnss-iam$ for item in iam libnss_iam.so.2 libnss-iam-0.1.deb; do
    aws $AWS_OPTS s3 cp --acl 'bucket-owner-full-control' "${item}" "s3://kops.cicdenv.com/libnss_iam/${item}"
    aws $AWS_OPTS s3api put-object-tagging --bucket=kops.cicdenv.com --key="libnss_iam/${item}" \
        --tagging 'TagSet=[{Key=Source,Value=https://github.com/vogtech/libnss-iam/tree/fred-01},{Key=Upstream,Value=https://github.com/gfleury/libnss-iam}]'
done
libnss-iam$ 
```
