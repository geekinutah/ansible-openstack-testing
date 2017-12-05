#!/usr/bin/env python3

import json
#from pprint import pprint

files = {'provisioner': None, 'computes': None, 'osds': None,
        'controllers': None}

for k in files.keys():
    with open('%s.json' % k) as f:
        j = json.load(f)
        files[k] = j
        f.close()

print('[provisioner]')
print(files['provisioner']['output_value'])
del(files['provisioner'])

for k in files.keys():
    print('[%s]' % k)
    for ip in files[k]['output_value']:
        print(ip)
