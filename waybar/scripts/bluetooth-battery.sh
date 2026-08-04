#!/usr/bin/env bash

# Find connected bluetooth devices via upower and report battery with a dynamic icon.
# Prints one JSON object, or empty string when no BT device reports battery.

# icons from the main battery module threshold (10 levels)
icons=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
charging_icons=("󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")

for dev in $(upower -e 2>/dev/null); do
  [ -z "$dev" ] && continue

  info=$(upower -i "$dev" 2>/dev/null)
  [ -z "$info" ] && continue

  # keep only real bluetooth devices (native-path contains /bluez/)
  native=$(printf '%s' "$info" | grep -i "native-path" | grep -o 'bluez' )
  [ -z "$native" ] && continue

  # percentage can be e.g. "100%", "N/A", or absent
  pct=$(printf '%s' "$info" | grep -i "percentage" | awk '{print $2}' | tr -d '%')
  # battery state: "charging", "discharging", "full", "unknown"
  state=$(printf '%s' "$info" | grep -i "state" | awk '{print $2}')
  model=$(printf '%s' "$info" | grep -i "^[[:space:]]*model:" | awk -F: '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  # skip if no usable numeric percentage
  if ! printf '%s' "$pct" | grep -qE '^[0-9]+$'; then
    continue
  fi

  # clamp 0-100
  pct=$((pct > 100 ? 100 : pct))
  idx=$((pct / 10))
  [ "$idx" -ge 10 ] && idx=9

  if [ "$state" = "charging" ]; then
    icon="${charging_icons[$idx]}"
  else
    icon="${icons[$idx]}"
  fi

  label="${model:-?}"
  # actual device label as known by bluetooth to use in tooltip if needed
  printf '{"text":"%s%% %s","alt":"%s","class":"bt-battery","tooltip":"%s: %s%%"}' \
    "$pct" "$icon" "$pct" "$label" "$pct"
  exit 0
done