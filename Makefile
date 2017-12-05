
all: deploy wait_30_seconds hostlist ssh_config ansible_prep ansible_go_install
	echo "Done"
deploy:
	openstack stack create -t templates/mitaka-openstack-ansible.yaml ansibleStack
hostlist:
	openstack stack output show ansibleStack provisioner_ip -fjson | sed 's/\\n//g' | sed 's/\\//g' | sed 's/\"\[/[/g' | sed 's/\]\"/]/g' | python -m json.tool > provisioner.json
	openstack stack output show ansibleStack compute_ips -fjson | sed 's/\\n//g' | sed 's/\\//g' | sed 's/\"\[/[/g' | sed 's/\]\"/]/g' | python -m json.tool > computes.json
	openstack stack output show ansibleStack controller_ips -fjson | sed 's/\\n//g' | sed 's/\\//g' | sed 's/\"\[/[/g' | sed 's/\]\"/]/g' | python -m json.tool > controllers.json
	openstack stack output show ansibleStack osd_ips -fjson | sed 's/\\n//g' | sed 's/\\//g' | sed 's/\"\[/[/g' | sed 's/\]\"/]/g' | python -m json.tool > osds.json
	mkdir -p ~/.ssh/config.d/
ssh_config: 
	./scripts/make_ssh_config.py > ~/.ssh/config.d/ansibleStack 
ansible_prep:
	echo "Implement me"
ansible_go_install:
	echo "Implement me"
clean:
	rm -f computes.json provisioner.json controllers.json osds.json
clean_all: clean
	openstack stack delete ansibleStack
wait_30_seconds:
	sleep 30
