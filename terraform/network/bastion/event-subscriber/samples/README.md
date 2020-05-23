## Items
* iam-cloudtrail-event.json - taken from cloudtrail event history in console
  * shows Active, Inactive UpdateSSHPublicKey event(s)
* lambda
  * event.json
    * event-message.json - message attribute is the same as `iam-cloudtrail-event.json`
  * context.py

```python
message = json.loads(event['Records']['Message'])

eventName = message['detail']['eventName']
status = message['detail']['requestParameters']['status']
if eventName == 'UpdateSSHPublicKey' and status == 'Inactive':
    userName = message['detail']['requestParameters']['userName']
    # Post message to all bastion host agents (close sessions for {userName})
```
