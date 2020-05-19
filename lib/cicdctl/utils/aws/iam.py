import boto3

from . import config_profile

def get_username(workspace='main'):
    session = boto3.Session(profile_name=config_profile(workspace))
    iam = session.client('iam')
    response = iam.get_user()
    # {
    #     "User": {
    #         "Path": "/users/",
    #         "UserName": "$USER",
    #         "UserId": "AIDAQG3KU4HV6AOKCVI3N",
    #         "Arn": "arn:aws:iam::014719181291:user/users/$USER",
    #     }
    # }
    return response['User']['UserName']
