#!/usr/bin/env bash

set -euo pipefail

plugin_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

session_name=$(tmux display-message -p "#S")

echo "Switched to $session_name"

new="$session_name $(date +%s)"

echo "$new" >> "$plugin_dir/log"

# TODO: Consider swapping timestamp/name position so itd be easy to sort
# NOTE: Need to configure tmux to skip updating sessions on resurrect
# set -g @resurrect-hook-pre-restore-all 'echo true > ~/.tmux-is-resurrecting'
if [ "$(cat "$plugin_dir/is_resurrecting")" = 'false' ]; then
  echo "Updating session $session_name..."

  if grep -q "$session_name " "$plugin_dir/age"; then
    sed -i '' "s/$session_name .*/$new/" "$plugin_dir/age"
  else
    echo "$new" >> "$plugin_dir/age"
  fi
else
  echo "Skipping saving session time because tmux is being restored"
fi
