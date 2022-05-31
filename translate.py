import os
import requests
import uuid
import json
from dotenv import load_dotenv

def load_variables():
    """Load up env variables of the API key & location"""
    env_var=load_dotenv('./variables.env')
    auth_dict = {"translator_key":os.environ['TRANSLATOR_KEY'],
            "translator_location":os.environ['TRANSLATOR_LOCATION']}
    return auth_dict

env_variables_dict = load_variables()
# Don't forget to replace with your Cog Services subscription key!
# If you prefer to use environment variables, see Extra Credit for more info.
subscription_key = env_variables_dict['translator_key']
location = env_variables_dict['translator_location']

# Our Flask route will supply two arguments: text_input and language_output.
# When the translate text button is pressed in our Flask app, the Ajax request
# will grab these values from our web app, and use them in the request.
# See main.js for Ajax calls.
def get_translation(text_input, language_output):
    base_url = 'https://api.cognitive.microsofttranslator.com'
    path = '/translate?api-version=3.0'
    params = '&to=' + language_output
    constructed_url = base_url + path + params

    headers = {
        'Ocp-Apim-Subscription-Key': subscription_key,
        'Ocp-Apim-Subscription-Region': location,
        'Content-type': 'application/json',
        'X-ClientTraceId': str(uuid.uuid4())
    }

    # You can pass more than one object in body.
    body = [{
        'text' : text_input
    }]
    response = requests.post(constructed_url, headers=headers, json=body)
    return response.json()
