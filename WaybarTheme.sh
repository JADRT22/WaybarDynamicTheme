#!/usr/bin/env bash

# =============================================================================
# WAYBAR DYNAMIC THEME - ALL-IN-ONE SCRIPT (v3.1)
# Description: Centralized management for wallpaper, layouts, and UI refresh.
# Author: JADRT22 (Fernando)
# =============================================================================

# --- PATH CONFIGURATION ---
WALLPAPER_DIR="$(xdg-user-dir PICTURES)/wallpapers"
CONFIG_DIR="$HOME/.config/WaybarDynamicTheme"
CONFIG_FILE="$CONFIG_DIR/config.conf"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
WAYBAR_CONFIG_FILE="$WAYBAR_CONFIG_DIR/config"
WAYBAR_LAYOUTS_DIR="$WAYBAR_CONFIG_DIR/configs"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"

# --- DEFAULT SETTINGS ---
TRANSITION_TYPE="random"
TRANSITION_FPS=60
TRANSITION_DURATION=2
TRANSITION_STEP=90

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

# --- UTILITY FUNCTIONS ---

# Function to update or add keys in the config file
update_config() {
    local key="$1"
    local value="$2"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "$key="$value"" > "$CONFIG_FILE"
    elif grep -q "^$key=" "$CONFIG_FILE"; then
        sed -i "s|^$key=.*|$key="$value"|" "$CONFIG_FILE"
    else
        echo "$key="$value"" >> "$CONFIG_FILE"
    fi
}

# Load current config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        notify-send -i dialog-error "Missing Dependency" "The tool '$1' was not found."
        exit 1
    fi
}

# --- CORE LOGIC FUNCTIONS ---

# 1. REFRESH UI COMPONENTS
refresh_ui() {
    # Reload GTK theme
    if command -v gsettings >/dev/null; then
        current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
        gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
        sleep 0.1
        gsettings set org.gnome.desktop.interface gtk-theme "$current_theme"
    fi

    # Kill running apps
    local apps=(waybar rofi swaync ags)
    for app in "${apps[@]}"; do
        pkill "${app}" 2>/dev/null
    done
    sleep 0.5

    # Restart Waybar
    if [ -L "$WAYBAR_CONFIG_FILE" ]; then
        current_config=$(readlink -f "$WAYBAR_CONFIG_FILE")
        waybar -c "$current_config" &
    else
        waybar &
    fi

    # Restart SwayNC
    if command -v swaync >/dev/null; then
        swaync >/dev/null 2>&1 &
        swaync-client --reload-config 2>/dev/null
    fi
}

# 2. SELECT WALLPAPER AND APPLY COLORS
switch_wallpaper() {
    check_command "swww"
    check_command "wallust"

    # Prepare Rofi input
    rofi_input=""
    while IFS= read -r pic; do
        name="${pic##*/}"
        rofi_input+="${name}\0icon\x1f${pic}
"
    done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

    # Show visual menu with a larger preview layout and clear names
    choice=$(echo -e "$rofi_input" | rofi -dmenu -i -p "󰸉 Select Wallpaper" \
        -show-icons -theme-str 'element { orientation: vertical; text-align: center; }' \
        -theme-str 'element-icon { size: 15ch; }' \
        -theme-str 'element-text { horizontal-align: 0.5; }' \
        -theme-str 'listview { columns: 3; lines: 2; }' \
        -theme-str 'window { width: 90ch; }' \
        -config "$ROFI_CONFIG")
    
    [ -z "$choice" ] && return

    selected_wall=$(find "$WALLPAPER_DIR" -iname "$choice" -print -quit)
    notify-send -i image-jpeg "Theme" "Applying colors for: $choice"

    # SWWW Transition
    if ! pgrep -x "swww-daemon" > /dev/null; then swww-daemon & sleep 0.5; fi
    effect=$TRANSITION_TYPE
    [ "$TRANSITION_TYPE" = "random" ] && effects=("grow" "wipe" "wave" "center" "outer" "any") && effect=${effects[$RANDOM % ${#effects[@]}]}

    swww img "$selected_wall" --transition-type "$effect" --transition-fps "$TRANSITION_FPS" --transition-duration "$TRANSITION_DURATION"

    # Save and Apply
    update_config "LAST_WALLPAPER" "$selected_wall"
    wallust run -s "$selected_wall" > /dev/null 2>&1
    refresh_ui
    notify-send -i checkbox-checked-symbolic "Theme" "Wallpaper updated!"
}

# 3. SELECT WAYBAR LAYOUT
switch_layout() {
    [ ! -d "$WAYBAR_LAYOUTS_DIR" ] && return
    layouts=$(ls "$WAYBAR_LAYOUTS_DIR" | sort)
    choice=$(echo -e "$layouts" | rofi -dmenu -i -p "󰕮 Choose Layout" -config "$ROFI_CONFIG")
    
    if [ ! -z "$choice" ] && [ -f "$WAYBAR_LAYOUTS_DIR/$choice" ]; then
        ln -sf "$WAYBAR_LAYOUTS_DIR/$choice" "$WAYBAR_CONFIG_FILE"
        update_config "WAYBAR_LAYOUT" "$choice"
        refresh_ui
        notify-send -i checkbox-checked-symbolic "Theme" "Layout changed: $choice"
    fi
}

# --- MENU FUNCTIONS ---

show_transition_menu() {
    options="󰈈 Random
󰈈 Grow
󰈈 Wipe
󰈈 Wave
󰈈 Center
󰈈 Outer"
    choice=$(echo -e "$options" | rofi -dmenu -i -p "󰵚 Transition" -config "$ROFI_CONFIG")
    if [ ! -z "$choice" ]; then
        new_type=$(echo "$choice" | awk '{print tolower($2)}')
        update_config "TRANSITION_TYPE" "$new_type"
        notify-send "Theme" "Transition set to: $new_type"
    fi
}

show_hub() {
    options="󰸉 Select Wallpaper
󰕮 Select Bar Layout
󰵚 Transition Animations
󰑐 Refresh Theme
󰒓 Project Info"
    choice=$(echo -e "$options" | rofi -dmenu -i -p "󱄄 Theme Hub" -config "$ROFI_CONFIG")
    
    case "$choice" in
        *"Select Wallpaper"*) switch_wallpaper ;;
        *"Select Bar Layout"*) switch_layout ;;
        *"Transition Animations"*) show_transition_menu ;;
        *"Refresh Theme"*) refresh_ui && notify-send "Theme" "System refreshed!" ;;
        *"Project Info"*) notify-send "Waybar Dynamic Theme" "Version 3.1
Created by JADRT22" ;;
    esac
}

# --- ARGUMENT PARSING ---
case "$1" in
    --refresh) refresh_ui ;;
    --switch)  switch_wallpaper ;;
    --layout)  switch_layout ;;
    --hub)     show_hub ;;
    *)         show_hub ;;
esac
