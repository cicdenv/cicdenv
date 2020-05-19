import json

import boto3
import requests

#
# Purpose:
#   Receives 'iam-user-updates' cloudwatch events from
#   us-east-1 IAM cloudtrail API calls
#   These arrive from SNS => lambda subscription
#   This lambda posts 'user' session close messages
#   to all bastion hosts in an account.
#

asg = boto3.client('autoscaling', region_name='us-west-2')
ec2 = boto3.resource('ec2', region_name='us-west-2')


def _private_ip(instance):
    return ec2.Instance(instance['InstanceId']).private_ip_address


def _private_ips(asg_name):
    instances = (asg
        .describe_auto_scaling_groups(AutoScalingGroupNames=[asg_name])
        .get("AutoScalingGroups")[0]
        .get('Instances')
    )
    return [_private_ip(instance) for instance in instances]


def lambda_handler(event, context):
    print(json.dumps(event))

    for record in event['Records']:
        message = json.loads(record['Sns']['Message'])
        
        eventName = message['detail']['eventName']
        status = message['detail']['requestParameters']['status']
    
        if eventName == 'UpdateSSHPublicKey' and status == 'Inactive':
            userName = message['detail']['requestParameters']['userName']
            print(userName)
            
            # Post message to all bastion host agents (close sessions for {userName})
            bastion_ips = _private_ips('bastion-service')
            print(f'bastion ips: {bastion_ips}')
            for bastion_ip in bastion_ips:
                response = requests.post(f'http://{bastion_ip}:5000/api/sessions/close', json={'iam_user': userName})
                print(f'{bastion_ip}: {response}')


if __name__ == "__main__":
    print(_private_ips('bastion-service'))
