## archive
```bash
cicdenv$ (cd terraform/kops/shared/ca-function; make lambda.zip)
cicdenv$ (cd terraform/kops/shared/ca-function; make upload)
```

## Links
* https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRotationTemplate/lambda_function.py
* https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_RotateSecret.html
* https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html
