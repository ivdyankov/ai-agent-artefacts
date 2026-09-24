#!/bin/bash
# Claude Code status line: [model.id] 📁 cwd 🌿 branch | token usage

input=$(cat)

model_id=$(echo "$input" | jq -r '.model.id // "unknown"')

cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
dir=$(basename "$cwd")

branch=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ] && [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
    branch="${branch}*"
  fi
fi

used_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')

# Round DOWN to nearest 1k and format as e.g. "34k"
tokens_fmt="$(( used_tokens / 1000 ))k"

# Percentage toward the 150k "reddest" threshold, capped at 100
threshold=150000
pct=$(( used_tokens * 100 / threshold ))
[ "$pct" -gt 100 ] && pct=100

# Color gradient green -> yellow -> orange -> red as usage approaches 150k
if [ "$pct" -lt 25 ]; then
  token_color=$'\033[38;5;46m'   # green
elif [ "$pct" -lt 50 ]; then
  token_color=$'\033[38;5;226m'  # yellow
elif [ "$pct" -lt 75 ]; then
  token_color=$'\033[38;5;208m'  # orange
else
  token_color=$'\033[38;5;196m'  # red
fi

base_color=$'\033[97m'   # bright white, for contrast on a dimmed background
reset=$'\033[0m'

folder_emoji="📁"
branch_emoji="🌿"

line="${base_color}[${model_id}] ${folder_emoji} ${dir}"
[ -n "$branch" ] && line="${line} ${branch_emoji} ${branch}"
line="${line} | ${token_color}${tokens_fmt}${reset}"

# --- Second line: session duration + cost ---
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

total_seconds=$(( duration_ms / 1000 ))
h=$(( total_seconds / 3600 ))
m=$(( (total_seconds % 3600) / 60 ))
s=$(( total_seconds % 60 ))

if [ "$h" -gt 0 ]; then
  duration_fmt="${h}h ${m}m"
elif [ "$m" -gt 0 ]; then
  duration_fmt="${m}m ${s}s"
else
  duration_fmt="${s}s"
fi

cost_fmt=$(printf '$%.2f' "$cost_usd")

clock_emoji="🕐"
money_emoji="💰"

line2="${base_color}${clock_emoji} ${duration_fmt} ${money_emoji} ${cost_fmt}${reset}"

printf '%s\n%s' "$line" "$line2"
