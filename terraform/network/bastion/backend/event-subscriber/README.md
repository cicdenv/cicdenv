## Testing
```bash
cicdenv$ (cd terraform/network/bastion/backend/event-subscriber; make)
cicdenv$ (cd terraform/network/bastion/backend/event-subscriber/target; AWS_PROFILE=admin-dev python lambda.py)

docker run --rm -it -p 5000:5000 -v /var/run/docker.sock:/var/run/docker.sock events-worker --host=0.0.0.0 --port 5000
```

## VPC
Permissions:
```
Error modifying Lambda Function Configuration:
InvalidParameterValueException: 
The provided execution role does not have permissions to call CreateNetworkInterface on EC2

ec2:CreateNetworkInterface
ec2:DescribeNetworkInterfaces
ec2:DeleteNetworkInterface
```

The AWS default policy has overly broad cloudwatch logs permissions:
```hcl
resource "aws_iam_role_policy_attachment" "iam_user_event_subscriber_vpc" {
  role       = aws_iam_role.iam_user_event_subscriber.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
```

arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
```

## Links
* https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html
  * https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
  * https://docs.aws.amazon.com/lambda/latest/dg/python-context.html
  * https://docs.aws.amazon.com/lambda/latest/dg/python-package.html
  * https://docs.aws.amazon.com/lambda/latest/dg/python-logging.html
* https://aws.amazon.com/premiumsupport/knowledge-center/build-python-lambda-deployment-package/
* https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html

SDK:
* http://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

Requests:
* https://requests.readthedocs.io/en/master/user/quickstart/

Boto3:
* https://boto3.amazonaws.com/v1/documentation/api/latest/guide/
