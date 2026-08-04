#!/usr/bin/env bash

config="$HOME/.config/waybar/cava.conf"
chars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
scale=1000
threshold=25

cava -p "$config" 2>/dev/null | while read -r line; do
  out=""
  max=0
  for v in $line; do
    v=${v%%.*}
    v=${v%%-*}
    [ -z "$v" ] && v=0
    [ "$v" -lt 0 ] && v=0
    [ "$v" -gt "$max" ] && max=$v
    idx=$(( v * 8 / scale ))
    [ "$idx" -ge 8 ] && idx=7
    [ "$idx" -lt 0 ] && idx=0
    out+="${chars[$idx]}"
  done

  if [ "$max" -ge "$threshold" ]; then
    printf '{"text":"%s","class":"cava"}\n' "$out"
  else
    printf '{"text":"","class":"hidden"}\n'
  fi
done