#!/usr/bin/env bash

set -euo pipefail

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux bind-key r run-shell "$current_dir/scripts/list_old.sh"

tmux set-hook -g client-session-changed "run-shell '$current_dir/scripts/session_change.sh'"

# https://github.com/tmux-plugins/tmux-resurrect/blob/master/docs/hooks.md
tmux set -g @resurrect-hook-pre-restore-all 'echo true > $current_dir/is_resurrecting'
tmux set -g @resurrect-hook-pre-restore-history 'echo false > $current_dir/is_resurrecting'

if [ ! -f "$current_dir/is_resurrecting" ]; then
  echo 'false' >> "$current_dir/is_resurrecting"
fi

if [ ! -f "$current_dir/age" ]; then
  touch "$current_dir/age"
fi

# FIXME: Prolly wanna iterate over each session and create a line when they're missing
