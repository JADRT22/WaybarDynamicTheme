#!/usr/bin/env bash

# =============================================================================
# PATH CONFIGURATION (EDIT IF NECESSARY)
# =============================================================================
WALLPAPER_DIR="$(xdg-user-dir PICTURES)/wallpapers"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
PYTHON_SCRIPT="$SCRIPTS_DIR/dynamic_theme.py"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
ROFI_THEME_DIR="$HOME/.config/rofi/themes"

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================
check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        notify-send "Error: Missing Dependency" "The tool '$1' was not found. Please install it."
        exit 1
    fi
}

# Check for essential dependencies
check_command "swww"
check_command "rofi"
check_command "python3"
check_command "magick"

# =============================================================================
# 1. CHOOSE WALLPAPER
# =============================================================================
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Error" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

mapfile -t PICS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \))

if [ ${#PICS[@]} -eq 0 ]; then
    notify-send "Error" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

CHOICE=$(printf "%s\n" "${PICS[@]##*/}" | rofi -dmenu -i -p "Select Wallpaper: ")

if [ -z "$CHOICE" ]; then
    exit 0
fi

SELECTED_WALL=$(find "$WALLPAPER_DIR" -iname "$CHOICE" -print -quit)

if [ ! -f "$SELECTED_WALL" ]; then
    notify-send "Error" "Selected file not found."
    exit 1
fi

# =============================================================================
# 2. SET WALLPAPER WITH SWWW
# =============================================================================
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    while ! swww query > /dev/null 2>&1; do
        sleep 0.1
    done
fi

swww img "$SELECTED_WALL" --transition-type grow --transition-pos 0.5,0.5 --transition-fps 60 --transition-duration 2

# =============================================================================
# 3. EXTRACT COLORS AND APPLY THEMES
# =============================================================================

# Python for custom colors
if [ -f "$PYTHON_SCRIPT" ]; then
    python3 "$PYTHON_SCRIPT" "$SELECTED_WALL"
else
    echo "Warning: Python script not found in $PYTHON_SCRIPT"
fi

# Wallust for systemic integration
if command -v wallust > /dev/null; then
    wallust run -s "$SELECTED_WALL"
fi

# =============================================================================
# 4. RESTART WAYBAR SAFELY
# =============================================================================
REFRESH_SCRIPT="$SCRIPTS_DIR/Refresh.sh"

if [ -f "$REFRESH_SCRIPT" ]; then
    "$REFRESH_SCRIPT"
else
    # Fallback if Refresh.sh doesn't exist
    pkill waybar
    while pgrep -x waybar > /dev/null; do sleep 0.1; done
    waybar & disown
fi

# =============================================================================
# 5. FINAL NOTIFICATION
# =============================================================================
notify-send "Dynamic Theme" "Wallpaper applied: $CHOICE"
