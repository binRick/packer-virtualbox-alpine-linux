#!/usr/bin/env bash
#source .v/bin/activate
#pip3 install j2-cli
set -oeu pipefail
cd "$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
FINAL_NAME="al3"

set -x

NOW=$(date +%s)
SRC_NAME=xxxxxxxxNAMExxxxxxxxxxx
DISTRO=${DISTRO:-alpine-3.14}
VMNAME=$DISTRO-$NOW
JSON=$VMNAME.json
CONSOLE_LOG=/tmp/console-$VMNAME.log


parse_fwd_port(){ 
  grep modifyvm $DISTRO.json|grep 'natpf1'|grep tcp|head -n1|tr ' ' '\n'|grep tcp|grep '"'|cut -d '"' -f2|cut -d, -f4
}

PACKER_LOG=.packer-build-$JSON-$NOW.log
START_LOG=.packer-start-$JSON-$NOW.log
IMPORT_LOG=.packer-import-$JSON-$NOW.log
VMENV="BUILD_TS=$NOW"
OVA=output-virtualbox-iso/$VMNAME.ova
NEW_PORT=0
CUR_PORT="$(parse_fwd_port)"
touch $CONSOLE_LOG

dot(){
  (
  set +x
  tail -q -n0 -F $CONSOLE_LOG |while read -r l; do
    msg="$(ansi --yellow --bg-black --italic "$l")"
    msg="$(ansi --blue --underline "$(date +%H:%M:%S)"):$(ansi --cyan --bold "$CONSOLE_LOG")>  $msg"
    echo -e "$msg"
  done
  ) &
}

dot &
bgpid=$!

clean(){
  set +e
  if [[ -e "/proc/$bgpid" ]]; then
    echo KILLING $bgpid
    kill $bgpid
  fi
}

trap clean EXIT

while [[ "$NEW_PORT" -lt 1025 || "$NEW_PORT" -gt 65000 ]]; do
  NEW_PORT="$(($(($(($(date +%s)/50241))+$RANDOM))/2))"
done

cmd="cat $DISTRO.json | gsed  \"s|$SRC_NAME|$VMNAME|g\" | gsed  \"s|$CUR_PORT|$NEW_PORT|g\" |tee .$JSON"
ansi --magetna --italic "$cmd"
eval "$cmd"

cmd="passh -L $PACKER_LOG packer build -force .$JSON"
ansi --blue --bold "$cmd" && eval "$cmd"

cmd="passh -L $IMPORT_LOG VBoxManage import $OVA --vsys 0 --vmname $VMNAME"
ansi --yellow --italic --bg-black "$cmd" && eval "$cmd"

cmd="passh -L $START_LOG VBoxManage startvm --putenv "$VMENV" --type headless $VMNAME"
ansi --red --bg-black "$cmd" && eval "$cmd"

export SSH_PORT=$NEW_PORT

sleep 1
cmd="VBoxManage controlvm $VMNAME acpipowerbutton"
ansi --red --bg-black "$cmd" && eval "$cmd" || true

sleep 20

exit 0

cmd="VBoxManage modifyvm $VMNAME --name $FINAL_NAME"
ansi --red --bg-black "$cmd" && eval "$cmd"
sleep 3
ansi --yellow --italic "$(VBoxManage showvminfo $FINAL_NAME |head -n 17)"

cmd="VBoxManage startvm $FINAL_NAME --type headless -E XX123=YY123"
ansi --red --bg-black "$cmd" && eval "$cmd"
sleep 3

