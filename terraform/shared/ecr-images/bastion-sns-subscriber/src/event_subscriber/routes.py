from flask import request
import requests
import json

from . import app

@app.route('/', methods=['GET', 'POST', 'PUT'])
def sns():
    payload = json.loads(request.data)
    print(payload)

    message_type = request.headers.get('X-Amz-Sns-Message-Type')
    if message_type == 'SubscriptionConfirmation' and 'SubscribeURL' in payload:
        subscribe_url = requests.get(payload['SubscribeURL'])
    elif message_type == 'Notification':
        message = payload['Message']
        print(message)
        # close any sessions for this user ...
    return 'OK\n'
