#!/bin/bash
set -oeu pipefail
docker ps || open /Applications/Docker.app
docker run -d --rm -e DISABLE_AUTHENTICATION=1 -p 8000:8000 -v $(pwd)/.restic-container:/data --name restic restic/rest-server rest-server --no-auth --path /data
