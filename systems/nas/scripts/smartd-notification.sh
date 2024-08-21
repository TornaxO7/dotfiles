#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl coreutils

HOOK="$(cat /run/agenix/discord-webhook)"
# echo 'curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"Found smart-error! Please take a look on it.\"}" "$HOOK"'
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"Found smart-error! Please take a look on it.\"}" "$HOOK"
