## Purpose
Per account lambda TLS key secret creator/rotator.

## archive
```bash
cicdenv$ (cd terraform/nginx/shared/tls-function; make)
```

## Links
* https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRotationTemplate/lambda_function.py
* https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_RotateSecret.html
* https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html
* https://github.com/lambci/docker-lambda/
* https://msftstack.wordpress.com/2016/10/15/generating-rsa-keys-with-python-3/
  * https://pypi.org/project/cryptography/
  * https://github.com/pyca/cryptography
