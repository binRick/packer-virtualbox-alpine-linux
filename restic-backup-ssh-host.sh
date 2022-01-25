#!/bin/bash
set -oeu pipefail
HOST="$1"
BACKUP_PATH="$2"

source .envrc

cmd="command ssh -oControlMaster=no  -R 127.0.0.1:8000:127.0.0.1:8000 -Att $HOST env RESTIC_REPOSITORY=$CONTAINER_RESTIC_REPOSITORY RESTIC_PASSWORD='$RESTIC_PASSWORD' restic backup --cleanup-cache --host $HOST \
 --exclude='/tmp/\*' \
 --exclude='\*/var/cache/\*' \
 --exclude='\*/.rustup/\*' \
 --exclude='/proc/\*' \
 --exclude='/sys/\*' \
 --exclude='/run/\*' \
 --exclude='/dev/\*' \
 --exclude='/run/\*' \
 --exclude='/var/tmp/\*' \
 --exclude='/var/spool/\*' \
 --exclude='/var/log/journal/\*' \
 --exclude='/usr1/\*' \
 --exclude='/var1/\*' \
 --exclude='\*/.find\*' \
 --exclude='/.restic\*' \
 --exclude='/.pv\*' \
 --exclude='\*/.restic\*' \
 --exclude='/.\*restic\*\*' \
 --exclude='/.swap\*' \
 --exclude='\*cache.restic\*' \
 --exclude='/root/.cache/\*' \
 --exclude='\*/.attic/\*' \
 --exclude='\*runc-overlayfs\*' \
 --exclude='/var/lib/containers/\*' \
 --exclude='/var/lib/docker/\*' \
 --exclude='\*/storage/overlay\*' \
 --exclude='/root/go/\*' \
 --exclude='/root/go1/\*' \
 --exclude='\*/target/debug/deps/\*' \
 --exclude='/root/YouCompleteMe/\*' \
 --exclude='\*/diagnostic.data/metrics.\*' \
 --exclude='\*/target/debug/build/\*' \
 --exclude='\*/data/docker/registry/\*' \
 --exclude='\*/.local/\*' \
 --exclude='\*/.cargo/\*' \
 --exclude='\*/.cache/\*' \
 --exclude='\*/.basher/\*' \
 --exclude='\*/.ipfs/\*' \
 --exclude='\*/.composer/\*' \
 --exclude='\*/.\*borg\*/\*' \
 --exclude='\*/.\*venv\*/\*' \
 --exclude='\*/.ansible\*/\*' \
 --exclude='\*/.npm/\*cache\*/\*' \
 --exclude='\*/pkg/mod/\*' \
 --exclude='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/\*' \
 --limit-upload 1500 $BACKUP_PATH"

ansi --yellow --italic --bg-black "$cmd"
eval "$cmd"

