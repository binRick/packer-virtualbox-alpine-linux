#!/bin/bash
set -oeu pipefail
HOST="$1"
BACKUP_PATH="$2"

source .envrc

cmd="command ssh -oControlMaster=no  -R 127.0.0.1:8000:127.0.0.1:8000 -Att $HOST env RESTIC_REPOSITORY=$CONTAINER_RESTIC_REPOSITORY RESTIC_PASSWORD='$RESTIC_PASSWORD' command restic backup -x --cleanup-cache --host $HOST --limit-upload 1500 $BACKUP_PATH"

ansi --yellow --italic --bg-black "$cmd"
eval "$cmd"

