## archive
```bash
📦 $USER:~/cicdenv$ (cd terraform/network/wireguard/backend/keys-function; make lambda.zip)
📦 $USER:~/cicdenv$ (cd terraform/network/wireguard/backend/keys-function; make upload)
```

## Test
```bash
📦 $USER:~/cicdenv$ (cd terraform/network/wireguard/backend/keys-function; python wg.py)
```

## Links
* https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRotationTemplate/lambda_function.py
* https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_RotateSecret.html
* https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html
