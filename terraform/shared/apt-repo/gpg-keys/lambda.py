import boto3
import logging
from os import environ

import json
from gpg import create_key

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
        secret_data, ascii_armored_public_keys = create_key()
        secret_value = json.dumps(secret_data)
        try:
            secrets_manager.put_secret_value(SecretId=arn, ClientRequestToken=token, SecretString=secret_value, VersionStages=['AWSPENDING'])
            logger.info(f'Successfully put secret for ARN {arn}, version="{token}".')
        except Exception:
            logger.exception("createSecret: error")
        try:
            bucket = environ["BUCKET"]
            key = f'{environ["KEY_PREFIX"]}/key.asc'
            s3.put_object(Bucket=bucket, Key=key, ContentType='application/pgp-keys', Body=ascii_armored_public_keys.encode('ascii'), ACL='public-read',)
            logger.info(f'Successfully put object for s3://{bucket}/{key}')
        except Exception:
            logger.exception(f'createSecret: "s3://{bucket}/{key}" - s3:put_object error')
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
