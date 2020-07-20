## Purpose
Per account lambda MySQL passwords secret creator/rotator.

## archive
```
cicdenv$ (cd terraform/mysql/shared/creds-function; make)
```

## upload
```
cicdenv$ (cd terraform/mysql/shared/creds-function; make push)
```

## Links
* https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRotationTemplate/lambda_function.py
* https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_RotateSecret.html
* https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html
* https://github.com/lambci/docker-lambda/
