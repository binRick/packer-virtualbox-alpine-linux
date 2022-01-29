#!/bin/bash
set -oeu pipefail

while read -r VM; do
	PORT="$(./vbox-get-vm-ssh-port.sh "$VM")"
	echo -e "$VM $PORT"
done < <(./vbox-list-vms.sh)
