from __future__ import print_function
from requests.auth import HTTPBasicAuth

import json
import requests
import os

print('Loading function')


def lambda_handler(event, context):
    
    if ('body' in event and event['body'] != ''):
        body = json.loads(event['body'])
        if ('message' in body and body['message'] != '') and (('email' in body and body['email'] != '') or ('phone' in body and body['phone'] != '')):
            name = body['name'] if 'name' in body and body['name'] != '' else 'Anonymous'
            payload = {
                    'FromEmail': os.environ['MAIL_FROM'],
                    'FromName': os.environ['MAIL_NAME'],
                    'Subject': os.environ['MAIL_SUBJECT'],
                    'Text-part': body['message'],
                    'Text-html': '<h2>'+body['name']+'<small>'+body['email']+'</small>'+'</h2>'+'<body>'+body['message']+'</body>',
                    'Recipients':[
                        {
                            "Email": os.environ['MAIL_TARGET']
                        }
                    ]
            }
            r = requests.post("https://"+os.environ['MAIL_API_HOST']+os.environ['MAIL_API_URL'], json=payload, auth=HTTPBasicAuth(os.environ['MAIL_USER'], os.environ['MAIL_PASS']))

            if r.status_code == 200:
                response = {
                        'statusCode': 200,
                        'body': r.text,
                        'headers': {
                            'Content-Type': 'application/json',
                            'Access-Control-Allow-Origin': '*'
                        }
                }
            else:
                response = {
                        'statusCode': r.status_code,
                        'body': r.text,
                        'headers': {
                            'Content-Type': 'application/json',
                            'Access-Control-Allow-Origin': '*'
                        }
                }
        else:
            response = {
                'statusCode': 400,
                'body': {
                    'ErrorMessage': 'The email could not be sent as no contact details were found (name or email)'
                }
            }
    else:
        response = {
            'statusCode': 400,
            'body': {
                'ErrorMessage': 'The email could not be sent as a malformed or non-existent body was found in the request'
            }
        }
    return response

