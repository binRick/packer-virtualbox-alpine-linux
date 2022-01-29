#!/usr/bin/env bash
set -oeu pipefail
VMs="$@"

while read -r VM; do
  set +e
	VBoxManage list vms | grep "^\"$VM\" "

	./vbox-stop-vm.sh "$VM" 2>/dev/null || true

	VBoxManage unregistervm $VM --delete
done < <(echo -e "$VMs" | tr ' ' '\n')
