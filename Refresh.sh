#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for refreshing waybar, rofi, swaync, wallust with increased flexibility

# =============================================================================
# PATH CONFIGURATION
# =============================================================================
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
WAYBAR_CONFIG_FILE="$WAYBAR_CONFIG_DIR/config"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
UserScripts="$HOME/.config/hypr/UserScripts"

# =============================================================================
# 1. KILL RUNNING PROCESSES
# =============================================================================
# List of processes to be restarted
_ps=(waybar rofi swaync ags)

for _prs in "${_ps[@]}"; do
  if pidof "${_prs}" >/dev/null; then
    pkill "${_prs}"
  fi
done

# Kill extra instances of cava (Waybar audio module)
if command -v killall >/dev/null; then
    killall cava 2>/dev/null
fi

# Short pause to ensure graceful termination
sleep 0.5

# Force kill if still alive
for _prs in "${_ps[@]}"; do
  if pidof "${_prs}" >/dev/null; then
    killall -9 "${_prs}" 2>/dev/null
  fi
done

# =============================================================================
# 2. RESTART WAYBAR WITH CURRENT CONFIG
# =============================================================================
if [ -L "$WAYBAR_CONFIG_FILE" ]; then
    CURRENT_CONFIG=$(readlink -f "$WAYBAR_CONFIG_FILE")
    # Try starting Waybar with the resolved file
    if [ -f "$CURRENT_CONFIG" ]; then
        waybar -c "$CURRENT_CONFIG" &
    else
        echo "Warning: Linked file not found: $CURRENT_CONFIG. Using default config."
        waybar &
    fi
else
    # If not a symlink, try the default file
    waybar &
fi

# =============================================================================
# 3. RESTART OTHER COMPONENTS
# =============================================================================

# Restart swaync (notifications) if installed
if command -v swaync >/dev/null; then
    swaync >/dev/null 2>&1 &
fi

# Reload swaync settings if the client exists
if command -v swaync-client >/dev/null; then
    swaync-client --reload-config 2>/dev/null
fi

# =============================================================================
# 4. EXECUTE USER SCRIPTS (EXTENSIONS)
# =============================================================================
if [ -f "${UserScripts}/RainbowBorders.sh" ]; then
  "${UserScripts}/RainbowBorders.sh" &
fi

exit 0
