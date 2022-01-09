#!/bin/bash
set -oeu pipefail

VBoxManage list vms | cut -d' ' -f1|cut -d\" -f2|sort -u
