
all: check_env deploy wait_30_seconds hostlist ssh_config ansible_inventory ansible_deployer_prep ansible_os_prep ansible_env_install
	echo "Done"
check_env:
	scripts/check_env.sh
deploy:
	openstack stack create -t templates/mitaka-openstack-ansible.yaml ansibleStack
hostlist:
	openstack stack output show ansibleStack jumphost_ip -fjson | sed 's/\\n//g' | sed 's/\\//g' | sed 's/\"\[/[/g' | sed 's/\]\"/]/g' | python -m json.tool > jumphost.json
	openstack stack output show ansibleStack deployer_ip -fjson | sed 's/\\n//g' | sed 's/\\//g' | sed 's/\"\[/[/g' | sed 's/\]\"/]/g' | python -m json.tool > deployer.json
	openstack stack output show ansibleStack compute_ips -fjson | sed 's/\\n//g' | sed 's/\\//g' | sed 's/\"\[/[/g' | sed 's/\]\"/]/g' | python -m json.tool > computes.json
	openstack stack output show ansibleStack controller_ips -fjson | sed 's/\\n//g' | sed 's/\\//g' | sed 's/\"\[/[/g' | sed 's/\]\"/]/g' | python -m json.tool > controllers.json
	openstack stack output show ansibleStack osd_ips -fjson | sed 's/\\n//g' | sed 's/\\//g' | sed 's/\"\[/[/g' | sed 's/\]\"/]/g' | python -m json.tool > osds.json
ssh_config: 
	mkdir -p ~/.ssh/config.d/
	./scripts/make_ssh_config.py > ~/.ssh/config.d/ansibleStack 
ansible_inventory:
	./scripts/make_ansible_inventory.py > inventory
ansible_deployer_prep:
	ssh ansible-deployer "sudo apt-get update"
	ssh ansible-deployer "sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=\"--force-confold\" --force-yes -fuy dist-upgrade"
	ssh ansible-deployer "sudo apt-get install -y aptitude build-essential git ntp ntpdate python-dev iptables"
	ssh ansible-deployer "if [ \! -d /opt/openstack-ansible ]; then sudo git clone -b 17.0.0.0b1 https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible;fi"
	ssh ansible-deployer "sudo sed -i 's/noexec,//g' /etc/fstab; sudo mount -oremount /tmp"
	ssh ansible-deployer "cd /opt/openstack-ansible && sudo ./scripts/bootstrap-ansible.sh"
	scp inventory ansible-deployer:./ 
	ssh ansible-deployer "if [ \! -d ansible-openstack-testing ]; then GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no' git clone git@github.com:geekinutah/ansible-openstack-testing.git;fi"
	ssh ansible-deployer "cd ansible-openstack-testing; cp playbooks/openstack-ansible-tasks.yaml .; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ~/inventory -l deployer -t deployer_bootstrap -f 15 -b openstack-ansible-tasks.yaml"
ansible_os_prep:
	ssh ansible-deployer "cd ansible-openstack-testing; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ~/inventory -f 15 -b openstack-ansible-tasks.yaml"
	echo "Reboot everything"
ansible_env_install:
	echo "Write openstack_user_config and variables, then run ansible everywhere"
clean:
	rm -f computes.json deployer.json controllers.json osds.json
	rm -f ~/.ssh/config.d/ansibleStack
	rm -f inventory
clean_all: clean
	openstack stack delete ansibleStack
wait_30_seconds:
	sleep 30
