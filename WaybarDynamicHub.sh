#!/usr/bin/env bash

# =============================================================================
# WAYBAR DYNAMIC HUB - VERSION 3.0
# Description: Central management hub for your dynamic theme.
# Author: JADRT22 (Fernando)
# =============================================================================

# --- PATH CONFIGURATION ---
PROJECT_DIR="$HOME/Projetos/WaybarDynamicTheme"
CONFIG_DIR="$HOME/.config/WaybarDynamicTheme"
CONFIG_FILE="$CONFIG_DIR/config.conf"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
WAYBAR_LAYOUTS_DIR="$WAYBAR_CONFIG_DIR/configs"
SWITCHER_SCRIPT="$HOME/.config/hypr/scripts/DynamicLayoutSwitcher.sh"
REFRESH_SCRIPT="$PROJECT_DIR/Refresh.sh"

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

# Function to update or add keys in the config file
update_config() {
    local key="$1"
    local value="$2"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "$key=\"$value\"" > "$CONFIG_FILE"
    elif grep -q "^$key=" "$CONFIG_FILE"; then
        sed -i "s|^$key=.*|$key=\"$value\"|" "$CONFIG_FILE"
    else
        echo "$key=\"$value\"" >> "$CONFIG_FILE"
    fi
}

# Load current config or set defaults
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    # Initial defaults
    TRANSITION_TYPE="random"
    WAYBAR_LAYOUT="default"
fi

# --- MENU FUNCTIONS ---

show_main_menu() {
    options="󰸉 Select Wallpaper
󰕮 Select Bar Layout
󰵚 Transition Animations
󰑐 Refresh Theme
󰒓 Project Info"
    
    choice=$(echo -e "$options" | rofi -dmenu -i -p "󱄄 Theme Hub" -config "~/.config/rofi/config.rasi")
    
    case "$choice" in
        *"Select Wallpaper"*)
            if [ -f "$SWITCHER_SCRIPT" ]; then
                "$SWITCHER_SCRIPT"
            else
                "$PROJECT_DIR/DynamicLayoutSwitcher.sh"
            fi
            ;;
        *"Select Bar Layout"*)
            show_layout_menu
            ;;
        *"Transition Animations"*)
            show_transition_menu
            ;;
        *"Refresh Theme"*)
            if [ -f "$REFRESH_SCRIPT" ]; then
                "$REFRESH_SCRIPT"
            else
                pkill waybar && waybar & disown
            fi
            notify-send -i checkbox-checked-symbolic "Theme Hub" "System refreshed!"
            ;;
        *"Project Info"*)
            notify-send -i help-about "Waybar Dynamic Theme" "Version 3.0
Developed by JADRT22"
            ;;
    esac
}

show_layout_menu() {
    if [ ! -d "$WAYBAR_LAYOUTS_DIR" ]; then
        notify-send -i dialog-error "Error" "Layout directory not found: $WAYBAR_LAYOUTS_DIR"
        return
    fi

    # List files from waybar configs directory
    layouts=$(ls "$WAYBAR_LAYOUTS_DIR" | sort)
    
    choice=$(echo -e "$layouts" | rofi -dmenu -i -p "󰕮 Choose Layout" -config "~/.config/rofi/config.rasi")
    
    if [ ! -z "$choice" ]; then
        target_layout="$WAYBAR_LAYOUTS_DIR/$choice"
        
        if [ -f "$target_layout" ]; then
            # Update Waybar config symlink
            ln -sf "$target_layout" "$WAYBAR_CONFIG_DIR/config"
            
            # Save to config file
            update_config "WAYBAR_LAYOUT" "$choice"
            
            # Refresh Waybar
            if [ -f "$REFRESH_SCRIPT" ]; then
                "$REFRESH_SCRIPT"
            fi
            
            notify-send -i checkbox-checked-symbolic "Theme Hub" "Layout changed to: $choice"
        fi
    fi
}

show_transition_menu() {
    options="󰈈 Random
󰈈 Grow
󰈈 Wipe
󰈈 Wave
󰈈 Center
󰈈 Outer"
    
    choice=$(echo -e "$options" | rofi -dmenu -i -p "󰵚 Select Transition" -config "~/.config/rofi/config.rasi")
    
    if [ ! -z "$choice" ]; then
        case "$choice" in
            *"Random"*) new_type="random" ;;
            *"Grow"*) new_type="grow" ;;
            *"Wipe"*) new_type="wipe" ;;
            *"Wave"*) new_type="wave" ;;
            *"Center"*) new_type="center" ;;
            *"Outer"*) new_type="outer" ;;
            *) exit 0 ;;
        esac
        
        update_config "TRANSITION_TYPE" "$new_type"
        notify-send -i dialog-information "Theme Hub" "Transition set to: $new_type"
    fi
}

# Start the menu
show_main_menu
