#!/usr/bin/env bash

# =============================================================================
# WAYBAR DYNAMIC THEME - MAIN SCRIPT
# Description: Choose wallpaper via Rofi and apply dynamic colors via Wallust.
# Author: JADRT22 (Fernando)
# Enhanced with AI assistance
# =============================================================================

# --- PATH CONFIGURATION ---
WALLPAPER_DIR="$(xdg-user-dir PICTURES)/wallpapers"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"

# --- PREMIUM TRANSITION SETTINGS ---
# Options: none, grow, wipe, wave, center, outer, any, random
TRANSITION_TYPE="random"
TRANSITION_FPS=60
TRANSITION_DURATION=2
TRANSITION_STEP=90

# --- UTILITY FUNCTIONS ---
check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        notify-send -i dialog-error "Missing Dependency" "The tool '$1' was not found. Please install it."
        exit 1
    fi
}

# Check for essential dependencies
check_command "swww"
check_command "rofi"
check_command "wallust"

# =============================================================================
# 1. CHOOSE WALLPAPER (VISUAL INTERFACE WITH PREVIEWS)
# =============================================================================
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send -i dialog-error "Dynamic Theme" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Prepare Rofi input with thumbnails
# Format: "Filename\0icon\x1f/full/path/to/image"
ROFI_INPUT=""
while IFS= read -r pic; do
    name="${pic##*/}"
    ROFI_INPUT+="${name}\0icon\x1f${pic}\n"
done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

if [ -z "$ROFI_INPUT" ]; then
    notify-send -i dialog-error "Dynamic Theme" "No wallpapers found in directory."
    exit 1
fi

# Show visual menu with icons enabled
CHOICE=$(echo -e "$ROFI_INPUT" | rofi -dmenu -i -p "󰸉 Select Wallpaper" \
    -show-icons -theme-str 'element-icon { size: 6ch; }' \
    -config "$ROFI_CONFIG")

if [ -z "$CHOICE" ]; then
    exit 0
fi

SELECTED_WALL=$(find "$WALLPAPER_DIR" -iname "$CHOICE" -print -quit)

if [ ! -f "$SELECTED_WALL" ]; then
    notify-send -i dialog-error "Dynamic Theme" "Selected file not found."
    exit 1
fi

# =============================================================================
# 2. APPLY THEME
# =============================================================================
notify-send -i image-jpeg "Dynamic Theme" "Applying colors for: $CHOICE"

# Set wallpaper with smooth premium transition
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.5
fi

# Determine transition effect (if random, pick one)
EFFECT=$TRANSITION_TYPE
if [ "$TRANSITION_TYPE" = "random" ]; then
    EFFECTS=("grow" "wipe" "wave" "center" "outer" "any")
    EFFECT=${EFFECTS[$RANDOM % ${#EFFECTS[@]}]}
fi

swww img "$SELECTED_WALL" \
    --transition-type "$EFFECT" \
    --transition-pos 0.5,0.5 \
    --transition-fps "$TRANSITION_FPS" \
    --transition-duration "$TRANSITION_DURATION" \
    --transition-step "$TRANSITION_STEP"

# Generate colors with Wallust (quiet mode)
wallust run -s "$SELECTED_WALL" > /dev/null 2>&1

# Refresh UI components (Waybar, etc.)
REFRESH_SCRIPT="./Refresh.sh"
if [ ! -f "$REFRESH_SCRIPT" ]; then
    REFRESH_SCRIPT="$SCRIPTS_DIR/Refresh.sh"
fi

if [ -f "$REFRESH_SCRIPT" ]; then
    "$REFRESH_SCRIPT" > /dev/null 2>&1
else
    # Fallback restart
    pkill waybar && waybar & disown
fi

# Final notification
notify-send -i checkbox-checked-symbolic "Dynamic Theme" "Theme updated successfully!"
