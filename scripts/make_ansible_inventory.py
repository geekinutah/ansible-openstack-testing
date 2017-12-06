#!/usr/bin/env python3

import json
#from pprint import pprint

files = {'deployer': None, 'computes': None, 'osds': None,
        'controllers': None}

for k in files.keys():
    with open('%s.json' % k) as f:
        j = json.load(f)
        files[k] = j
        f.close()

print('[deployer]')
deployer_ip = files['deployer']['output_value']
del(files['deployer'])
print('%s deployer_ip=%s' % (deployer_ip, deployer_ip))

for k in files.keys():
    print('[%s]' % k)
    for ip in files[k]['output_value']:
        print('%s deployer_ip=%s' % (ip, deployer_ip))
