#!/bin/bash
set -oeu pipefail
VM="$1"

VBoxManage showvminfo $VM | grep '^NIC .* Rule(' | tr ',' '\n' | grep 'host port' | cut -d= -f2 | sed 's/[[:space:]]//g'
