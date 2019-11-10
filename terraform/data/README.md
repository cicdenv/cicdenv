## Purpose
Text file oriented data repository for info coming from
various sub-accounts.

This seems lame - it is.

When centralizing certain resources it is advantageous to 
make terraform 'data-driven' in its lookup of lists of 
resources realized in each account.

Some examples:
* S3 VPC endpoints - used for authorizing bucket access

NOTE:
```
This is most useful for cross state / function use cases.

Example: kops|test VPCs should be able to access the custom 
         s3 apt-repo via their respective s3 VPC endpoints
```
