import boto3

_region = 'us-west-2'
_topic = f'arn:aws:sns:{_region}:014719181291:iam-user-updates'


class Subscriber(object):
    def __init__(self, endpoint):
        self.endpoint = endpoint
        self.client = boto3.client('sns', _region)

    def subscribe(self):
        # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sns.html#SNS.Client.subscribe
        response = self.client.subscribe(
            TopicArn=_topic,
            Protocol=self.endpoint.split(':')[0],
            Endpoint=self.endpoint,
            Attributes={},
            ReturnSubscriptionArn=True
        )
        print(response)
        self.subscription_arn = response['SubscriptionArn']
    
    
    def unsubscribe(self):
        # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sns.html#SNS.Client.unsubscribe
        if self.subscription_arn:
            response = self.client.unsubscribe(SubscriptionArn=self.subscription_arn)
            print(response)
    