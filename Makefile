
all: deploy wait_30_seconds hostlist ssh_config ansible_prep ansible_env_install
	echo "Done"
check_env:
	scripts/check_env.sh
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
	ssh ansible-deployer "sudo apt-get update"
	ssh ansible-deployer "sudo apt-get dist-upgrade -y"
	ssh ansible-deployer "sudo apt-get install -y aptitude build-essential git ntp ntpdate python-dev"
	ssh ansible-deployer "sudo git clone -b 17.0.0.0b1 https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible"
	ssh ansible-deployer "sudo sed -i 's/noexec,//g'; sudo mount -oremount /tmp"
	ssh ansible-deployer "sudo cd /opt/openstack-ansible; sudo ./scripts/bootstrap-ansible.sh"
	echo "Implement the rest of deployer automation"
ansible_env_install:
	echo "Implement me"
clean:
	rm -f computes.json provisioner.json controllers.json osds.json
	rm -f ~/.ssh/config.d/ansibleStack
clean_all: clean
	openstack stack delete ansibleStack
wait_30_seconds:
	sleep 30
