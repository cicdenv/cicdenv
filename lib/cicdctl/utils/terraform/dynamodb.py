import re

import boto3

from ..aws import DEFAULT_REGION, config_profile

# parses:  dynamodb[<table>][<field>]
# example: dynamodb[kops-clusters][FQDN]
dynamodb_ref_regex = re.compile(r'''
dynamodb              # dynamodb
\[(?P<table>[^[]+)\]  # table name
\[(?P<field>[^[]+)\]  # field name
''', re.VERBOSE)

def get_items(dynamodb_ref, workspace, region=DEFAULT_REGION):
    session = boto3.session.Session(profile_name=config_profile(workspace))
    dynamodb = session.resource('dynamodb', region_name=region)

    match = dynamodb_ref_regex.match(dynamodb_ref)
    table_name = match['table']
    field_name = match['field']

    table = dynamodb.Table(table_name)
    response = table.scan()
    items = response['Items']
    
    values = [f'"{item[field_name]}"' for item in items]
    
    # in the form of a terraform rhs cli list assignment
    return f'[{",".join(values)}]'
