#!/bin/bash
set -oeu pipefail


while read -r k; do
  echo -e "${k}=\"xxxxxxxxxxx\""
< <(./get-build-var-keys.sh)

