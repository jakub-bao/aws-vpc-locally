import requests

url = 'http://52.202.38.206'

def main(event, context):
    try:
        resp = requests.get(url, timeout=5)
        return f'status: {resp.status_code}, response: {resp.text}'
    except Exception as e:
        print(e)
