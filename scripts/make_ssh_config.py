#!/usr/bin/env python3

import json
#from pprint import pprint
from jinja2 import Template

files = {'deployer': None, 'computes': None, 'osds': None,
        'controllers': None}
templates = {'jumphost': None, 'host': None}
host_template = None
jumphost_template = None

for t in templates.keys():
    with open('templates/ssh_%s.jinja2' % t) as f:
        templates[t] = Template(f.read())
        f.close()

for k in files.keys():
    with open('%s.json' % k) as f:
        j = json.load(f)
        files[k] = j
        f.close()

print(templates['jumphost'].render(ip=files['deployer']['output_value']))

del(files['deployer'])

for k in files.keys():
    for i in range(0, len(files[k]['output_value'])):
        ip_list = files[k]['output_value']
        print(templates['host'].render(ip=ip_list[i], name=k,sequence=i))


#{'computes': {u'description': u'Compute IPs',
#              u'output_key': u'compute_ips',
#              u'output_value': [u'192.168.10.18',
#                                u'192.168.10.17',
#                                u'192.168.10.19']},
# 'controllers': {u'description': u'Controller IPs',
#                 u'output_key': u'controller_ips',
#                 u'output_value': [u'192.168.10.15',
#                                   u'192.168.10.14',
#                                   u'192.168.10.16']},
# 'osds': {u'description': u'OSD IPs',
#          u'output_key': u'osd_ips',
#          u'output_value': [u'192.168.10.22',
#                            u'192.168.10.20',
#                            u'192.168.10.21']},
# 'deployer': {u'description': u'Ansible Deployer IP',
#                 u'output_key': u'deployer_ip',
#                 u'output_value': u'10.42.36.209'}}
#

