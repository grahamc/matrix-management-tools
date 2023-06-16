#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq file matrix-synapse.tools.synadm -I nixpkgs=channel:nixos-unstable-small
# shellcheck shell=bash
set -eux
set -o pipefail

homeserver=https://nixos.ems.host
AUTH_TOKEN=$(cat ~/.config/synadm.yaml | grep '^token:'| cut -d' ' -f2)
HOMESERVER=$homeserver
export AUTH_TOKEN
scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
finish() {
  rm -rf "$scratch"
}
trap finish EXIT

get_ratelimit() (
  user=$1
  curl \
    --silent \
    -H "Authorization: Bearer ${AUTH_TOKEN}" \
    "https://nixos.ems.host/_synapse/admin/v1/users/$user/override_ratelimit" \
    | jq .
)

set_ratelimit() (
  user=$1
  messages_per_second=$2
  burst_count=$3

  payload=$(jq -n '
      {}
      | .messages_per_second = ($messages_per_second | tonumber)
      | .burst_count = ($burst_count | tonumber)
    ' \
    --arg messages_per_second "$messages_per_second" \
    --arg burst_count "$burst_count")

  curl \
    --silent \
    -H "Authorization: Bearer ${AUTH_TOKEN}" \
    --data "$payload" \
    "https://nixos.ems.host/_synapse/admin/v1/users/$user/override_ratelimit" \
    | jq .
)



username=@mjolnir:nixos.org
get_ratelimit "$username"
echo "continue?"
read x

set_ratelimit "$username" 0 0

