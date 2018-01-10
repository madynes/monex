import requests
from prometheus_client import start_http_server, Gauge
import socket


node_name = socket.gethostname()
h = {}
url = 'http://127.0.0.1:9091/transmission/rpc'

def updateHeader():
    global h
    data = requests.get(url)
    h = {'X-Transmission-Session-Id':data.headers['X-Transmission-Session-Id']}

def get_data(g):
    payload = {'method':'torrent-get','arguments':{"ids": [1], "fields": ['percentDone']}}
    resp = requests.post(url, headers=h, json=payload)

    if resp.status_code != 200:
        updateHeader()
        resp = requests.post(url, headers=h, json=payload)
    value = resp.json()['arguments']['torrents'][0]['percentDone']
    g.labels(node_name).set(value)


g_torrent = Gauge('percent', '% of torrent', ['node'])

start_http_server(8000)
print('Starting metric...')

while True:
    get_data(g_torrent)


