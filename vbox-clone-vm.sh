#!/bin/bash
set -oeu pipefail
SRC=$1
DST=$2

cmd="VBoxManage clonevm '$SRC' --name='$DST' --register"
ansi --yellow --italic "$cmd"
eval "$cmd"
