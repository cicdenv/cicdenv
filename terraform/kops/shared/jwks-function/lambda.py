import boto3
import logging
import os

import json
from jwks import create_jwks

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    arn = event['SecretId']
    token = event['ClientRequestToken']
    step = event['Step']
    logger.info(f'arn: {arn}, token: {token}, step: {step}')

    secrets_manager = boto3.client(service_name='secretsmanager', region_name='us-west-2')
    s3 = boto3.client(service_name='s3', region_name='us-west-2')

    metadata = secrets_manager.describe_secret(SecretId=arn)

    versions = metadata['VersionIdsToStages']
    if token not in versions:
        message = f'Secret version="{token}" - has no stage for rotation of secret: {arn}.'
        logger.error(message)
        raise ValueError(message)
    if "AWSCURRENT" in versions[token]:
        logger.info(f'Secret version="{token}" - already set as AWSCURRENT for secret: {arn}.')
        return
    elif "AWSPENDING" not in versions[token]:
        message = f'Secret version="{token}" - not set as AWSPENDING for rotation of secret: {arn}.'
        logger.error(message)
        raise ValueError(message)

    if step == "createSecret":
        secret_data, jwks_json = create_jwks('/tmp/jwks')
        secret_value = json.dumps(secret_data)
        try:
            secrets_manager.put_secret_value(SecretId=arn, ClientRequestToken=token, SecretString=secret_value, VersionStages=['AWSPENDING'])
            logger.info(f'Successfully put secret for ARN {arn}, version="{token}".')
        except Exception:
            logger.exception("createSecret: secrets manager - put secret value error")
        try:
            s3.put_object(Bucket=os.environ["OIDC_BUCKET"], Key='jwks.json', ContentType='application/json', Body=jwks_json.encode(), ACL='public-read',)
            logger.info(f'Successfully put object for s3://{os.environ["OIDC_BUCKET"]}/jwks.json')
        except Exception:
            logger.exception(f'createSecret: s3://{os.environ["OIDC_BUCKET"]}/jwks.json - s3:put_object error')
    elif step == "setSecret":
        pass  # N/A
    elif step == "testSecret":
        pass  # N/A
    elif step == "finishSecret":
        metadata = secrets_manager.describe_secret(SecretId=arn)
        current_version = None
        for version in metadata["VersionIdsToStages"]:
            if "AWSCURRENT" in metadata["VersionIdsToStages"][version]:
                if version == token:
                    logger.info(f'finishSecret: Version "{version}" already marked as AWSCURRENT for {arn}')
                    return
                current_version = version
                break
        secrets_manager.update_secret_version_stage(SecretId=arn, VersionStage="AWSCURRENT", MoveToVersionId=token, RemoveFromVersionId=current_version)
        logger.info(f'finishSecret: Successfully set AWSCURRENT stage to version="{token}" for secret {arn}.')
