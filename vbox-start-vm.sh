#!/bin/bash
set -oeu pipefail
VMs="${@:-}"

MAX=9999
get_unique_vm_int() {

	local i="$(($(echo "$VM" | tr '[A-Z]' '[a-z]' | tr '[a-z]' '6') * 1024))"
	while [[ "$i" -gt $MAX ]]; do
		i="$(($i / 10))"
	done
	echo -e "$i"
}

cb="bridge666"
vbnet() {
	u="$(get_unique_vm_int)"
	b="bridge$u"
	if ! sudo wg show utun2; then
		sudo -u root -n wg-quick up utun2
	fi
	sudo ifconfig $b delete 2>/dev/null || true
	sudo ifconfig $cb create 2>/dev/null || true
	sudo ifconfig $b create 2>/dev/null || true
	ansi --yellow --italic --bg-black "$(sudo ifconfig $b)"

	#  sudo wg show interfaces|grep '^utun2$' ||
	#$VM"
	#$(($(ifconfig|grep bridge|wc -l)+1))
	#sudo ifconfig $b addm en2
	#sudo ifconfig $b addm utun2
	sudo ifconfig $b up
}

while read -r VM; do
	VM=$VM vbnet
	./vbox-get-vm-nics.sh $VM
	VBoxManage modifyvm $VM --nic1 nat
	VBoxManage modifyvm $VM --nic2 bridged --bridgeadapter2 $b
	VBoxManage modifyvm $VM --nic3 bridged --bridgeadapter3 $cb
	VBoxManage modifyvm $VM --nic4 none
	./vbox-get-vm-nics.sh $VM
	VBoxManage startvm --type headless $VM
done < <(echo -e "$VMs" | tr ' ' '\n')
