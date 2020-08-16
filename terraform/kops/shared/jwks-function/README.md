## Purpose
IAM Roles for (Kubernetes) Service Accounts integration component.

Generates a key pair and updates the Open ID Connect discovery 
endpoint config, key config public files.

## archive
```bash
cicdenv$ (cd terraform/kops/shared/jwks-function; make lambda.zip)
📦 $USER:~/cicdenv$ (cd terraform/kops/shared/jwks-function; make upload)
```

## Console Test
NOTE: `ClientRequestToken` needs a sentinel value for testing
```json
{
  "SecretId": "irsa-service-accounts",
  "ClientRequestToken": "<uuid>",
  "Step": "createSecret"
}
```

## Verify
```bash
for item in account-signing-key account-signing-key-pkcs8.pub; do
AWS_PROFILE=admin-<workspace>            \
AWS_REGION=us-west-2                     \
aws secretsmanager get-secret-value      \
    --secret-id "irsa-service-accounts"  \
    --version-stage 'AWSCURRENT'         \
    --query  'SecretString'              \
| jq -r "fromjson | .[\"$item\"]"        \
| base64 -di
done

curl https://oidc-irsa-<workspace>-cicdenv-com.s3.amazonaws.com/.well-known/openid-configuration
curl https://oidc-irsa-<workspace>-cicdenv-com.s3.amazonaws.com/jwks.json
```

## Links
* https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRotationTemplate/lambda_function.py
* https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_RotateSecret.html
* https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html
