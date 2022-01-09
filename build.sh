#!/usr/bin/env bash
set -oeu pipefail
cd "$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
FINAL_NAME="${1:-new-vm}"
NOW="`date +%s`"
SRC_NAME=xxxxxxxxNAMExxxxxxxxxxx
DISTRO=${DISTRO:-alpine-3.14}
VMNAME=$DISTRO-$NOW
JSON=$VMNAME.json
CONSOLE_LOG=/tmp/console-$VMNAME.log

source build-vars.sh
SSH_CONFIG_INCLUDE_FILE=$SSH_CONFIG_INCLUDE_DIR/$FINAL_NAME
PKGS="${PKGS:-$ALL_PKGS}"


parse_fwd_port() {
	grep modifyvm $DISTRO.json | grep 'natpf1' | grep tcp | head -n1 | tr ' ' '\n' | grep tcp | grep '"' | cut -d '"' -f2 | cut -d, -f4
}

PACKER_LOG=.packer-build-$JSON-$NOW.log
START_LOG=.packer-start-$JSON-$NOW.log
IMPORT_LOG=.packer-import-$JSON-$NOW.log
VMENV="BUILD_TS=$NOW"
OVA=output-virtualbox-iso/$VMNAME.ova
NEW_PORT=0
CUR_PORT="$(parse_fwd_port)"
touch $CONSOLE_LOG

tail_console() (
		set +x
		tail -q -n0 -F $CONSOLE_LOG | while read -r _l; do
			[[ "$_l" == "" ]] && continue
			while read -r l; do
			  [[ "$l" == "" ]] && continue
        b="$(echo -e "$l"|wc -c)"
        [[ "$b" -lt 4 ]] && continue
				msg="$(ansi --yellow --bg-black --italic " $l")"
        b=
				msg="$(ansi --blue --underline "$(date +%H:%M:%S)") $(ansi --green --bold "$b") $(ansi --green --bold ">") $msg"
				echo -e "$msg"
			done < <(echo -e "$_l")
		done
)

tail_console &
bgpid=$!

clean() {
	set +e
	kill $bgpid || true
}

trap clean EXIT

while [[ "$NEW_PORT" -lt 1025 || "$NEW_PORT" -gt 65000 ]]; do
	NEW_PORT="$(($(($(($(date +%s) / 50241)) + $RANDOM)) / 2))"
done

SSH_PORT=$NEW_PORT

if ! docker ps --filter name=apk-cache |grep apk-cache; then
  docker run -d -p $APK_PROXY_PORT:80 --name=apk-cache quay.io/vektorcloud/apk-cache:latest
fi



cmd="cat $DISTRO.json | gsed  \"s|$SRC_NAME|$VMNAME|g\" | gsed  \"s|$CUR_PORT|$NEW_PORT|g\" |tee .$JSON"
ansi --magetna --italic "$cmd"
eval "$cmd"

HEADLESS=${HEADLESS:-true}

cmd="passh -L $PACKER_LOG \
  packer build \
    -force \
    -color=true \
    -on-error=run-cleanup-provisioner \
    -var SSH_PORT=$SSH_PORT \
    -var MB=$MB \
    -var CPUS=$CPUS \
    -var ZSH_THEME=$ZSH_THEME \
    -var DISK_MB=$DISK_MB \
    -var PKGS='$PKGS' \
    -var APK_PROXY_HOST=$APK_PROXY_HOST \
    -var APK_PROXY_PORT=$APK_PROXY_PORT \
    -var SSH_PUBLIC_RSA_KEY=$SSH_PUBLIC_RSA_KEY \
    -var HEADLESS=$HEADLESS \
      .$JSON"

[[ -d output-virtualbox-iso ]] && rm -rf output-virtualbox-iso

ansi --blue --bold "$cmd" && eval "$cmd"

./vbox-backup-ova.sh $OVA

cmd="passh -L $IMPORT_LOG VBoxManage import $OVA --vsys 0 --ostype Linux26_64 --vmname '$FINAL_NAME'"
ansi --yellow --italic --bg-black "$cmd" && eval "$cmd"

cmd="passh -L $START_LOG VBoxManage startvm --type headless $FINAL_NAME"
ansi --red --bg-black "$cmd" && eval "$cmd"

exit 0

sleep 15

OK=
qty=0
while [[ "$OK" != 1 ]]; do
  timeout 5 passh ./ssh-vbox-vm.sh "$FINAL_NAME" ip addr && OK=1
  qty=$(($qty+1))
  [[ "$qty" -gt 120 ]] && exit 1
  sleep 1
done  


echo OK
exit 0
