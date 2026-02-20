#!/usr/bin/env bash

# =============================================================================
# WAYBAR DYNAMIC THEME - MAIN SCRIPT
# Description: Choose wallpaper via Rofi and apply dynamic colors via Wallust.
# Author: JADRT22 (Fernando)
# =============================================================================

# --- PATH CONFIGURATION ---
WALLPAPER_DIR="$(xdg-user-dir PICTURES)/wallpapers"
PROJECT_DIR="$HOME/Projetos/WaybarDynamicTheme"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"
CONFIG_FILE="$HOME/.config/WaybarDynamicTheme/config.conf"

# --- DEFAULT PREMIUM TRANSITION SETTINGS ---
TRANSITION_TYPE="random"
TRANSITION_FPS=60
TRANSITION_DURATION=2
TRANSITION_STEP=90

# Source current config if exists
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

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

# Function to update config file
update_config() {
    local key="$1"
    local value="$2"
    mkdir -p "$(dirname "$CONFIG_FILE")"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "$key=\"$value\"" > "$CONFIG_FILE"
    elif grep -q "^$key=" "$CONFIG_FILE"; then
        sed -i "s|^$key=.*|$key=\"$value\"|" "$CONFIG_FILE"
    else
        echo "$key=\"$value\"" >> "$CONFIG_FILE"
    fi
}

# =============================================================================
# 1. CHOOSE WALLPAPER (VISUAL INTERFACE WITH PREVIEWS)
# =============================================================================
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send -i dialog-error "Dynamic Theme" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Prepare Rofi input with thumbnails
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

# Ensure swww-daemon is running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.5
fi

# Determine transition effect
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

# Save current wallpaper for persistence
update_config "LAST_WALLPAPER" "$SELECTED_WALL"

# Generate colors with Wallust
wallust run -s "$SELECTED_WALL" > /dev/null 2>&1

# Refresh UI components
REFRESH_SCRIPT="$PROJECT_DIR/Refresh.sh"
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
