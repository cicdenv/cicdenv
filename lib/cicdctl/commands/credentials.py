from aws.credentials import StsAssumeRoleCredentials, MfaCodeGenerator
from terraform.outputs import get_output


def run_creds(args):
    creds_command = args.creds_command
    if creds_command == "aws-mfa":
        StsAssumeRoleCredentials().refresh_profile('admin-main')
        for workspace in args.workspace:
            StsAssumeRoleCredentials().refresh_profile(f'admin-{workspace}')
    elif creds_command == "mfa-code":
        print(MfaCodeGenerator().next().decode('utf-8').rstrip())
    elif creds_command == "switch-role-url":
        for workspace in args.workspace:
            StsAssumeRoleCredentials().refresh_profile(f'admin-{workspace}')
            print(get_output(workspace, 'iam/organization-account', 'switch_role_url'))
