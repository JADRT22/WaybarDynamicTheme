#!/usr/bin/env bash

# =============================================================================
# WAYBAR DYNAMIC THEME - REFRESH SCRIPT
# Description: Gracefully restarts Waybar, Rofi, and SwayNC and reloads GTK themes.
# Author: JADRT22 (Fernando)
# =============================================================================

# --- PATH CONFIGURATION ---
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
WAYBAR_CONFIG_FILE="$WAYBAR_CONFIG_DIR/config"

# --- UTILITY FUNCTIONS ---

# Function to reload GTK theme without closing windows
reload_gtk() {
    if command -v gsettings >/dev/null; then
        # Get current theme
        current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")
        # "Touch" the theme to force reload Wallust CSS
        gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" # Temp change
        sleep 0.1
        gsettings set org.gnome.desktop.interface gtk-theme "$current_theme" # Revert to original
    fi
}

kill_processes() {
    # List of processes to be restarted
    local apps=(waybar rofi swaync ags)
    
    for app in "${apps[@]}"; do
        if pidof "${app}" >/dev/null; then
            pkill "${app}"
        fi
    done

    # Force kill if still alive after pause
    sleep 0.5
    for app in "${apps[@]}"; do
        if pidof "${app}" >/dev/null; then
            killall -9 "${app}" 2>/dev/null
        fi
    done
}

# =============================================================================
# 1. KILL RUNNING PROCESSES
# =============================================================================
kill_processes

# =============================================================================
# 2. RESTART WAYBAR WITH CURRENT CONFIG
# =============================================================================
if [ -L "$WAYBAR_CONFIG_FILE" ]; then
    CURRENT_CONFIG=$(readlink -f "$WAYBAR_CONFIG_FILE")
    # Start Waybar with the resolved file
    if [ -f "$CURRENT_CONFIG" ]; then
        waybar -c "$CURRENT_CONFIG" &
    else
        echo "Warning: Linked file not found: $CURRENT_CONFIG. Using default config."
        waybar &
    fi
else
    # If not a symlink, use the default file
    waybar &
fi

# =============================================================================
# 3. RESTART OTHER COMPONENTS AND RELOAD GTK
# =============================================================================

# Reload CSS for open GTK windows
reload_gtk

# Restart swaync (notifications) if installed
if command -v swaync >/dev/null; then
    swaync >/dev/null 2>&1 &
fi

# Reload swaync settings if client exists
if command -v swaync-client >/dev/null; then
    swaync-client --reload-config 2>/dev/null
fi

exit 0
