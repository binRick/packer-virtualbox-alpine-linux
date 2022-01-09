#!/bin/bash
set -oeu pipefail
VM=$1

VBoxManage startvm --type headless $VM
