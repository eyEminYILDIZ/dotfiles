#!/bin/bash

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
[ -z "$cwd" ] && cwd="$PWD"

dir="${cwd##*/}"
[ -z "$dir" ] && dir="/"

model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

meta="Model: $model"
[ -n "$effort" ] && meta="$meta ($effort)"
if [ -n "$ctx_size" ]; then
  if [ "$((ctx_size % 1000000))" -eq 0 ]; then
    ctx_size_fmt="$((ctx_size / 1000000))M"
  else
    ctx_size_fmt="$((ctx_size / 1000))K"
  fi
  meta="$meta [${ctx_size_fmt}]"
fi

# Builds a 10-block usage bar from an integer percentage
make_bar() {
  local pct="$1" bar_width=10 filled empty bar="" fill pad
  filled=$((pct * bar_width / 100))
  empty=$((bar_width - filled))
  [ "$filled" -gt 0 ] && printf -v fill '%*s' "$filled" '' && bar="${fill// /▓}"
  [ "$empty" -gt 0 ] && printf -v pad '%*s' "$empty" '' && bar="${bar}${pad// /░}"
  echo "$bar"
}

# Context window usage
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
ctx_bar=$(make_bar "$ctx_pct")

line="Dir: $dir | $meta | Context: $ctx_bar ${ctx_pct}%"

# Claude subscription rate limit usage (5-hour and 7-day windows)
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

if [ -n "$five_h" ] || [ -n "$seven_d" ]; then
  limits=""
  if [ -n "$five_h" ]; then
    fh_pct=$(printf '%.0f' "$five_h")
    limits="5h: $(make_bar "$fh_pct") ${fh_pct}%"
  fi
  if [ -n "$seven_d" ]; then
    wk_pct=$(printf '%.0f' "$seven_d")
    limits="${limits:+$limits | }7d: $(make_bar "$wk_pct") ${wk_pct}%"
  fi
  line="$line | $limits"
fi

echo "$line"
