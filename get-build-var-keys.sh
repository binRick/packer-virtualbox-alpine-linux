#!/bin/bash
set -oeu pipefail
cat build-vars.sh|cut -d= -f1|sort -u
