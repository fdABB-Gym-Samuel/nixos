#!/usr/bin/env bash

# Script to cycle to next wallpaper on specified monitor
# Usage: ./next-wallpaper.sh [monitor-name] [--current]
# Example: ./next-wallpaper.sh DP-3
#          ./next-wallpaper.sh DP-3 --current  (reload last wallpaper)

if ! pgrep -x hyprpaper >/dev/null; then
  echo "Error: hyprpaper is not running"
  hyprctl dispatch exec hyprpaper
  sleep 1
fi

WALLPAPER_DIR="$HOME/images/backgrounds"
STATE_DIR="$HOME/.cache/hyprpaper"

# Parse arguments
RELOAD_CURRENT=false
MONITOR=""

for arg in "$@"; do
  if [ "$arg" = "--current" ]; then
    RELOAD_CURRENT=true
  else
    MONITOR="$arg"
  fi
done

# Default to DP-3 if no monitor specified
MONITOR="${MONITOR:-DP-3}"

# Check if monitor exists
if ! hyprctl monitors | grep -q "^Monitor $MONITOR "; then
  echo "Error: Monitor $MONITOR not found"
  echo "Available monitors:"
  hyprctl monitors | grep "^Monitor" | awk '{print $2}'
  exit 1
fi

# Create state directory if it doesn't exist
mkdir -p "$STATE_DIR"

STATE_FILE="$STATE_DIR/current_${MONITOR}"

# Get all wallpapers recursively
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  echo "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

# Get current wallpaper for this monitor
if [ -f "$STATE_FILE" ]; then
  CURRENT_WALLPAPER=$(cat "$STATE_FILE")
else
  CURRENT_WALLPAPER=""
fi

# If --current flag is set, just reload the current wallpaper
if [ "$RELOAD_CURRENT" = true ]; then
  if [ -z "$CURRENT_WALLPAPER" ]; then
    echo "No previous wallpaper found for $MONITOR, loading first wallpaper"
    WALLPAPER_TO_SET="${WALLPAPERS[0]}"
  elif [ ! -f "$CURRENT_WALLPAPER" ]; then
    echo "Previous wallpaper no longer exists, loading first wallpaper"
    WALLPAPER_TO_SET="${WALLPAPERS[0]}"
  else
    WALLPAPER_TO_SET="$CURRENT_WALLPAPER"
  fi

  hyprctl hyprpaper preload "$WALLPAPER_TO_SET"
  hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER_TO_SET"
  echo "$WALLPAPER_TO_SET" >"$STATE_FILE"
  echo "Reloaded $MONITOR: $WALLPAPER_TO_SET"
  exit 0
fi

# Find current wallpaper in array
CURRENT_INDEX=-1
for i in "${!WALLPAPERS[@]}"; do
  if [ "${WALLPAPERS[$i]}" = "$CURRENT_WALLPAPER" ]; then
    CURRENT_INDEX=$i
    break
  fi
done

# Calculate next index (wrap around)
NEXT_INDEX=$(((CURRENT_INDEX + 1) % ${#WALLPAPERS[@]}))
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Preload new wallpaper
hyprctl hyprpaper preload "$NEXT_WALLPAPER"

# Set wallpaper
hyprctl hyprpaper wallpaper "$MONITOR,$NEXT_WALLPAPER"

# Unload old wallpaper if it exists and is different
if [ -n "$CURRENT_WALLPAPER" ] && [ "$CURRENT_WALLPAPER" != "$NEXT_WALLPAPER" ]; then
  hyprctl hyprpaper unload "$CURRENT_WALLPAPER"
fi

# Save new wallpaper path
echo "$NEXT_WALLPAPER" >"$STATE_FILE"

echo "Set $MONITOR to: $NEXT_WALLPAPER"
