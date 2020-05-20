import json
import re

from urllib.parse import urlencode

#
# Redicts: https://jenkins.cicdenv.com/securityRealm/finishLogin/{account}/{instance}
#      to: https://jenkins-{instance}.{account}.cicdenv.com/securityRealm/finishLogin
#

def lambda_handler(event, context):
    print(json.dumps(event))
    print(vars(context))

    # /securityRealm/finishLogin/{account}/{instance}
    path = event['path']
    print(f'path: {path}')

    # ?code=...&state=...
    query_string = event['queryStringParameters']
    print(query_string)

    # extract account, instance name
    path_pattern = re.compile(r'/securityRealm\/finishLogin\/(?P<account>.+)\/(?P<instance>.+)')
    parsed = path_pattern.match(path)
    
    account = parsed.group('account')
    instance = parsed.group('instance')

    encoded_query_string = urlencode(query_string)

    # specific jenkins service instance Github OAuth callback URL
    location = f'https://jenkins-{instance}.{account}.cicdenv.com/securityRealm/finishLogin?{encoded_query_string}'
    print(f'location: {location}')

    response = {
        'isBase64Encoded': False,
        'statusCode': 302,
        'headers': {
            'Location': location,
        },
        'body': '',
    }
    print(json.dumps(response))

    return response
