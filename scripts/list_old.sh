#!/usr/bin/env bash

# FIXME: Need to handle I think when a session exists in age list history but has been removed from tmux

set -euo pipefail

plugin_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

while read -r session; do
  log=$(grep "^$session " "$plugin_dir/age" || echo '')

  if [ -n "$log" ]; then
    timestamp=$(echo "$log" | cut -d ' ' -f 2)
    now=$(date +%s)
    age_seconds=$(("$now" - "$timestamp"))
    age_days=$(("$age_seconds" / 60 / 24))
    if [ "$age_days" -ge 7 ]; then
      color="\e[1;31m"
    else
      color="\e[1;92m"
    fi
    printf "%s: %b%s days\e[0m\n" "$session" "$color" "$age_days"
  else
    printf "%s: -\n" "$session"
  fi
done < <(tmux list-sessions -F '#{session_name}')

