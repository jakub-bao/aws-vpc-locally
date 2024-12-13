import requests

url = 'https://checkip.amazonaws.com'

def main(event, context):
    resp = requests.get(url)
    return f'status: {resp.status_code}, response: {resp.text}'
