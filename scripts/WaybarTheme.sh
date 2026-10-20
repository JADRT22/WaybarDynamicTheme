#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# WAYBAR DYNAMIC THEME - ALL-IN-ONE SCRIPT (v4.1)
# Description: Centralized management for wallpaper, layouts, and UI refresh.
# Author: JADRT22 (Fernando)
# =============================================================================

# --- PATH CONFIGURATION ---
# xdg-user-dir may be absent on minimal installs: falling back keeps the
# script alive under `set -e`.
if command -v xdg-user-dir >/dev/null 2>&1; then
    PICTURES_DIR="$(xdg-user-dir PICTURES)"
else
    PICTURES_DIR="$HOME/Pictures"
fi
WALLPAPER_DIR="$PICTURES_DIR/wallpapers"
CONFIG_DIR="$HOME/.config/WaybarDynamicTheme"
CONFIG_FILE="$CONFIG_DIR/config.conf"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
WAYBAR_LAYOUTS_DIR="$WAYBAR_CONFIG_DIR/configs"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"

# Modern Waybar looks for `config.jsonc` before `config` (Alexays feature),
# so a symlink named `config` alone would be ignored. Prefer what already
# exists and default to `config.jsonc` when neither is present.
resolve_waybar_config() {
    if [ -e "$WAYBAR_CONFIG_DIR/config.jsonc" ]; then
        echo "$WAYBAR_CONFIG_DIR/config.jsonc"
    elif [ -e "$WAYBAR_CONFIG_DIR/config" ]; then
        echo "$WAYBAR_CONFIG_DIR/config"
    else
        echo "$WAYBAR_CONFIG_DIR/config.jsonc"
    fi
}
WAYBAR_CONFIG_FILE="$(resolve_waybar_config)"

# --- DEFAULT SETTINGS ---
TRANSITION_TYPE="random"
TRANSITION_FPS=60
TRANSITION_DURATION=2
TRANSITION_STEP=90
# 0 = keep wallust terminal sequences (required by kitty/ghostty templates)
# 1 = pass -s / --skip-sequences to wallust (colors only, no escape sequences)
SKIP_SEQUENCES=0

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

# --- UTILITY FUNCTIONS ---

# Function to update or add keys in the config file
update_config() {
    local key="$1"
    local value="$2"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "${key}=\"${value}\"" > "$CONFIG_FILE"
    elif grep -q "^${key}=" "$CONFIG_FILE"; then
        # Safe under `set -e`: `grep -q` runs as an if/elif condition, so a
        # "not found" status (1) is expected and never aborts the script.
        sed -i "s|^${key}=.*|${key}=\"${value}\"|" "$CONFIG_FILE"
    else
        echo "${key}=\"${value}\"" >> "$CONFIG_FILE"
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

# Run wallust on an image, honoring SKIP_SEQUENCES.
# Redirected output is intentional, but failures still surface as a notification
# so `set -e` never kills the hub silently.
run_wallust() {
    local image="$1"
    if [ "${SKIP_SEQUENCES:-0}" = "1" ]; then
        wallust run -s "$image" >/dev/null 2>&1 || notify-send -i dialog-error "Theme" "wallust failed"
    else
        wallust run "$image" >/dev/null 2>&1 || notify-send -i dialog-error "Theme" "wallust failed"
    fi
}

# --- CORE LOGIC FUNCTIONS ---

# 1. REFRESH UI COMPONENTS
refresh_ui() {
    # Reload GTK theme (toggle forces apps to re-read the injected CSS)
    if command -v gsettings >/dev/null 2>&1; then
        local current_theme=""
        current_theme="$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null || true)"
        current_theme="$(echo "$current_theme" | sed "s/'//g")"
        if [ -n "$current_theme" ]; then
            gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" 2>/dev/null || true
            sleep 0.1
            gsettings set org.gnome.desktop.interface gtk-theme "$current_theme" 2>/dev/null || true
        fi
    fi

    # Kill running apps (pkill exits 1 when nothing matches)
    local apps=(waybar rofi swaync ags)
    local app
    for app in "${apps[@]}"; do
        pkill "${app}" 2>/dev/null || true
    done
    sleep 0.5

    # Restart Waybar
    if [ -L "$WAYBAR_CONFIG_FILE" ]; then
        local current_config=""
        current_config="$(readlink -f "$WAYBAR_CONFIG_FILE")"
        if [ -f "$current_config" ]; then
            waybar -c "$current_config" &
        else
            waybar &
        fi
    else
        waybar &
    fi

    # Restart SwayNC
    if command -v swaync >/dev/null 2>&1; then
        swaync >/dev/null 2>&1 &
        # SwayNC needs a moment to create its socket before it can be reloaded
        sleep 0.5
        swaync-client --reload-config >/dev/null 2>&1 || true
    fi
}

# 2. SELECT WALLPAPER AND APPLY COLORS
switch_wallpaper() {
    check_command "swww"
    check_command "wallust"

    # Build the rofi input and the lookup arrays in the SAME sorted loop,
    # so the index returned by rofi always maps to the right file.
    local rofi_input="" pic name
    local -a wallpaper_names=()
    local -a wallpaper_paths=()
    while IFS= read -r pic; do
        name="${pic##*/}"
        wallpaper_names+=("$name")
        wallpaper_paths+=("$pic")
        rofi_input+="${name}\0icon\x1f${pic}\n"
    done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null | sort || true)

    if [ "${#wallpaper_paths[@]}" -eq 0 ]; then
        notify-send -i dialog-warning "Theme" "No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi

    # Show visual menu with a larger preview layout and clear names
    # Remembering last selected row for Fernando
    # rofi exits non-zero on Escape: the `|| true` keeps the pipeline safe.
    local choice=""
    choice="$(echo -e "$rofi_input" | rofi -dmenu -i -p "󰸉 Select Wallpaper" \
        -show-icons -theme-str 'element { orientation: vertical; text-align: center; }' \
        -theme-str 'element-icon { size: 15ch; }' \
        -theme-str 'element-text { horizontal-align: 0.5; }' \
        -theme-str 'listview { columns: 3; lines: 2; }' \
        -theme-str 'window { width: 90ch; }' \
        -selected-row "${LAST_WALLPAPER_INDEX:-0}" \
        -format i \
        -config "$ROFI_CONFIG" || true)"

    if [ -z "$choice" ]; then
        return 1
    fi

    # `-format i` gives us the 0-based index of the selected row
    local selected_index="$choice"
    if ! [[ "$selected_index" =~ ^[0-9]+$ ]] || [ "$selected_index" -ge "${#wallpaper_paths[@]}" ]; then
        return 1
    fi

    local selected_wall="${wallpaper_paths[$selected_index]}"
    local selected_name="${wallpaper_names[$selected_index]}"
    if [ -z "$selected_wall" ] || [ ! -f "$selected_wall" ]; then
        return 1
    fi

    notify-send -i image-jpeg "Theme" "Applying colors for: $selected_name"

    # SWWW Transition (query is a real "is the daemon alive?" test)
    if ! swww query &>/dev/null; then
        swww-daemon &
        sleep 0.5
    fi
    local effect="$TRANSITION_TYPE"
    if [ "$TRANSITION_TYPE" = "random" ]; then
        local -a effects=("grow" "wipe" "wave" "center" "outer" "any")
        effect="${effects[$((RANDOM % ${#effects[@]}))]}"
    fi

    swww img "$selected_wall" --transition-type "$effect" --transition-fps "$TRANSITION_FPS" --transition-duration "$TRANSITION_DURATION" \
        || notify-send -i dialog-error "Theme" "swww failed to set wallpaper"

    # Save and Apply
    update_config "LAST_WALLPAPER" "$selected_wall"
    update_config "LAST_WALLPAPER_INDEX" "$selected_index"
    run_wallust "$selected_wall"
    refresh_ui
    notify-send -i checkbox-checked-symbolic "Theme" "Wallpaper updated!"
}

# 3. SELECT WAYBAR LAYOUT
switch_layout() {
    if [ ! -d "$WAYBAR_LAYOUTS_DIR" ]; then
        return 1
    fi

    # Prepare the list with the back option
    local layouts="" options="" choice=""
    layouts="$(ls "$WAYBAR_LAYOUTS_DIR" | sort)"
    options="󰌍 Back to Hub\n$layouts"

    choice="$(echo -e "$options" | rofi -dmenu -i -p "󰕮 Choose Layout" \
        -theme-str 'listview { columns: 1; }' \
        -theme-str 'element-text { horizontal-align: 0; }' \
        -config "$ROFI_CONFIG" || true)"

    if [ -z "$choice" ] || [ "$choice" == "󰌍 Back to Hub" ]; then
        show_hub
        return 0
    fi

    if [ -f "$WAYBAR_LAYOUTS_DIR/$choice" ]; then
        ln -sf "$WAYBAR_LAYOUTS_DIR/$choice" "$WAYBAR_CONFIG_FILE"
        update_config "WAYBAR_LAYOUT" "$choice"
        refresh_ui
        notify-send -i checkbox-checked-symbolic "Theme" "Layout changed: $choice"
    fi
}

# --- MENU FUNCTIONS ---

show_transition_menu() {
    local options="󰌍 Back to Hub\n󰈈 Random\n󰈈 Grow\n󰈈 Wipe\n󰈈 Wave\n󰈈 Center\n󰈈 Outer"
    local choice=""
    choice="$(echo -e "$options" | rofi -dmenu -i -p "󰵚 Transition" \
        -theme-str 'listview { columns: 1; }' \
        -theme-str 'element-text { horizontal-align: 0; }' \
        -config "$ROFI_CONFIG" || true)"

    if [ -z "$choice" ] || [ "$choice" == "󰌍 Back to Hub" ]; then
        show_hub
        return 0
    fi

    if [ ! -z "$choice" ]; then
        local new_type=""
        new_type="$(echo "$choice" | awk '{print tolower($2)}')"
        update_config "TRANSITION_TYPE" "$new_type"
        notify-send "Theme" "Transition set to: $new_type"
        show_hub # Return to hub after selection
        return 0
    fi
}

show_hub() {
    local options="󰸉 Select Wallpaper\n󰕮 Select Bar Layout\n󰵚 Transition Animations\n󰑐 Refresh Theme\n󰒓 Project Info"
    local choice=""
    choice="$(echo -e "$options" | rofi -dmenu -i -p "󱄄 Theme Hub" \
        -theme-str 'listview { columns: 1; }' \
        -theme-str 'element-text { horizontal-align: 0; }' \
        -config "$ROFI_CONFIG" || true)"

    # Sub-menus return 1 when the user cancels: `|| true` keeps the hub alive.
    case "$choice" in
        *"Select Wallpaper"*) switch_wallpaper || true ;;
        *"Select Bar Layout"*) switch_layout || true ;;
        *"Transition Animations"*) show_transition_menu || true ;;
        *"Refresh Theme"*) refresh_ui && notify-send "Theme" "System refreshed!" ;;
        *"Project Info"*) notify-send "Waybar Dynamic Theme" "Version 4.1\nCreated by JADRT22" ;;
    esac
    return 0
}

# --- LOGIN RESTORE (autostart) ---
# Reapplies the last wallpaper and its palette without touching the UI:
# Waybar and SwayNC are already started by the session autostart.
restore_wallpaper() {
    check_command "swww"
    check_command "wallust"

    # Cover the race with the session's own swww-daemon autostart
    local attempt
    for attempt in 1 2 3; do
        if swww query &>/dev/null; then
            break
        fi
        swww-daemon >/dev/null 2>&1 &
        sleep 0.5
    done

    if [ -z "${LAST_WALLPAPER:-}" ] || [ ! -f "$LAST_WALLPAPER" ]; then
        notify-send -i dialog-information "Theme" "No saved wallpaper to restore"
        return 0
    fi

    # Instant swap on login: no animation
    swww img "$LAST_WALLPAPER" --transition-type simple --transition-fps "$TRANSITION_FPS" --transition-duration 0 \
        || notify-send -i dialog-error "Theme" "swww failed to restore wallpaper"

    run_wallust "$LAST_WALLPAPER"
    return 0
}

# --- ARGUMENT PARSING ---
case "${1:-}" in
    --refresh) refresh_ui ;;
    --switch)  switch_wallpaper ;;
    --layout)  switch_layout ;;
    --restore) restore_wallpaper ;;
    --hub)     show_hub ;;
    *)         show_hub ;;
esac
