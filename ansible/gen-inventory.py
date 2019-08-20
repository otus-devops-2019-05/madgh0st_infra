#!/usr/bin/env python3
#
import json
import yaml

from pprint import pprint

import subprocess

rslt=subprocess.run(['/usr/bin/gcloud','compute','instances','list','--format=json'],
    stdout=subprocess.PIPE)


data = json.loads(rslt.stdout.decode('utf-8'))

result = [{
            'name' : a['name'],
            'ansible_host': a['networkInterfaces'][0]['accessConfigs'][0]['natIP'],
            'project':  a['machineType'].split('/')[6],
            'zone':     a['machineType'].split('/')[8],
            'tags' : a['tags']['items'][0],
            'ansible_ssh_user' : 'appuser',
            'ansible_ssh_key': 'auto_ssh_key=~/.ssh/appuser'
        } for a in data  ]

inventory = {}

for s in result:
    if s['tags'] not in inventory.keys():
        inventory[s['tags']] = []
    inventory[s['tags']].append(s['ansible_host'])

print(json.dumps(inventory))

