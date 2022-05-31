import os, requests, uuid, json
from dotenv import load_dotenv

def load_variables():
    """Load up env variables of the API key & location"""
    env_var=load_dotenv('./variables.env')
    auth_dict = {"text_analytics_key":os.environ['TEXT_ANALYTICS_KEY'],
            "text_analytics_location":os.environ['TEXT_ANALYTICS_LOCATION'],
            "text_analytics_name":os.environ['TEXT_ANALYTICS_NAME'],
            }
    return auth_dict

env_variables_dict = load_variables()
# Don't forget to replace with your Cog Services subscription key!
subscription_key = env_variables_dict['text_analytics_key']
location = env_variables_dict['text_analytics_location']
resource_name = env_variables_dict['text_analytics_name']

# Our Flask route will supply four arguments: input_text, input_language,
# output_text, output_language.
# When the run sentiment analysis button is pressed in our Flask app,
# the Ajax request will grab these values from our web app, and use them
# in the request. See main.js for Ajax calls.

def get_sentiment(input_text, input_language, output_text, output_language):
    #base_url = 'https://westus.api.cognitive.microsoft.com/text/analytics'
    base_url = f'https://{resource_name}.cognitiveservices.azure.com/'
    path = '/v2.0/sentiment'
    constructed_url = base_url + path

    headers = {
        'Ocp-Apim-Subscription-Key': subscription_key,
        'Ocp-Apim-Subscription-Region': location,
        'Content-type': 'application/json',
        'X-ClientTraceId': str(uuid.uuid4())
    }

    # You can pass more than one object in body.
    body = {
        'documents': [
            {
                'language': input_language,
                'id': '1',
                'text': input_text
            },
            {
                'language': output_language,
                'id': '2',
                'text': output_text
            }
        ]
    }
    response = requests.post(constructed_url, headers=headers, json=body)
    return response.json()
