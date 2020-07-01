## archive
```
cicdenv$ (cd terraform/kops/shared/ca-function; make lambda.zip)
```

## cfssl Layer
```bash
📦 $USER:~/cicdenv$ (cd terraform/kops/shared/ca-function; make layer.zip)
zip layer.zip /bin/{cfssl,cfssljson}
  adding: bin/cfssl (deflated 70%)
  adding: bin/cfssljson (deflated 69%)
```

## Links
* https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRotationTemplate/lambda_function.py
* https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_RotateSecret.html
* https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html
