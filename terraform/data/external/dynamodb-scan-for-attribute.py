#!/usr/bin/python

import boto3

from terraform_external_data import terraform_external_data


@terraform_external_data
def get_items(inputs):
    dynamodb = boto3.resource('dynamodb')

    table_name = inputs['dynamodb_table']
    field_name = inputs['attribute']

    table = dynamodb.Table(table_name)
    response = table.scan()
    items = response['Items']
    
    values = [item[field_name] for item in items]
    
    return {
        'items': ','.join(values),
    }

if __name__ == "__main__":
    get_items()
