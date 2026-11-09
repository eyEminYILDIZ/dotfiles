#!/usr/bin/env bash
# Prints the battery level of connected Bluetooth devices for polybar.
# Prints nothing (module hidden) if no connected device reports a battery.
icon=$(printf '')   # Font Awesome headphones
out=""
for mac in $(bluetoothctl devices Connected 2>/dev/null | awk '{print $2}'); do
  info=$(bluetoothctl info "$mac" 2>/dev/null)
  bat=$(grep -oP 'Battery Percentage: 0x\w+ \(\K[0-9]+' <<<"$info")
  [ -z "$bat" ] && continue
  if   [ "$bat" -le 15 ]; then color="#e60053"
  elif [ "$bat" -le 30 ]; then color="#f5a70a"
  else color=""; fi
  if [ -n "$color" ]; then txt="%{F$color}$icon $bat%%{F-}"; else txt="$icon $bat%"; fi
  out="${out:+$out  }$txt"
done
echo "$out"
