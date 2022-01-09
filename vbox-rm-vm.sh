#!/bin/bash
set -oeu pipefail
VM=$1

VBoxManage list vms | grep "^\"$VM\" "

./vbox-stop-vm.sh "$VM" 2>/dev/null||true

VBoxManage unregistervm $VM --delete
