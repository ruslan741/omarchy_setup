#!/usr/bin/env bash

# Media control button for waybar. Shows an icon only when an MPRIS player is
# present; prints nothing (hides the module) otherwise.
# Usage: media-button.sh <previous|next|play-pause>

action="$1"

playing=false
if status=$(playerctl status 2>/dev/null); then
  [ "$status" = "Playing" ] && playing=true
fi

case "$action" in
  previous)
    printf '{"text":"󰒮","alt":"prev","class":"media-prev","tooltip":"Previous"}'
    ;;
  next)
    printf '{"text":"󰒭","alt":"next","class":"media-next","tooltip":"Next"}'
    ;;
  play-pause)
    if [ "$playing" = true ]; then
      printf '{"text":"󰏤","alt":"playing","class":"media-playpause","tooltip":"Pause"}'
    else
      printf '{"text":"󰐊","alt":"paused","class":"media-playpause","tooltip":"Play"}'
    fi
    ;;
esac