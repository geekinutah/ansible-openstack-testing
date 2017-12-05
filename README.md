# ansible-openstack-testing
---

## Contents
---

* templates/ - Contains one Heat template and a bunch of templates for the ansible playbook
* playbook/ - Currently only one
* config/ - Ansible-openstack deployment configs 
* scripts/ - helper scripts
## Usage
---

Open up the Makefile and you will see several targets, if you just use

` $ make `

things will most likely work. Per norm, the **clean** target will do a cleanup of intermediary files. The **clean_all** target will clean up the entire Heat stack. 

## Known problems
---

* Deleting the ansibleStack doesn't usually work, if you delete all the instances first as a workaround you can then delete the entire stack.
