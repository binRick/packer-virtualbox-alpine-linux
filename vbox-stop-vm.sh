#!/bin/bash
set -oeu pipefail
VM=$1

VBoxManage list runningvms | grep "^\"$VM\" " && VBoxManage controlvm $VM poweroff
