#!/usr/bin/env bash

# Corrected paths for your system
WALLPAPER_DIR="$HOME/Imagens/wallpapers"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
PYTHON_SCRIPT="$SCRIPTS_DIR/dynamic_theme.py"
WAYBAR_STYLE_DIR="$HOME/.config/waybar/style"
ROFI_THEME_DIR="$HOME/.config/rofi/themes"

# 1. Choose Wallpaper
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

# 2. Set Wallpaper with SWWW
if pgrep -x "swww-daemon" > /dev/null; then
    swww img "$SELECTED_WALL" --transition-type grow --transition-pos 0.5,0.5 --transition-fps 60 --transition-duration 2
else
    swww-daemon &
    sleep 1
    swww img "$SELECTED_WALL"
fi

# 3. Extract Colors with Python (Fallback)
# Python saves to ~/.config/waybar/dynamic_colors.css
python3 "$PYTHON_SCRIPT" "$SELECTED_WALL"

# 4. Apply new style to Waybar (COMMENTED TO PRESERVE USER CHOICE)
# We now leave the style that the user chose in the style menu.
# ln -sf "$WAYBAR_STYLE_DIR/dynamic_minimal.css" "$HOME/.config/waybar/style.css"

# 4.5 Ensure colors are extracted by Wallust (configured for all themes)
if command -v wallust > /dev/null; then
    wallust run -s "$SELECTED_WALL"
fi

# 5. Restart Waybar safely
# We use Refresh.sh to ensure the current layout and style are maintained
if [ -f "$SCRIPTS_DIR/Refresh.sh" ]; then
    "$SCRIPTS_DIR/Refresh.sh"
else
    if pgrep -x "waybar" > /dev/null; then
        pkill waybar
        while pgrep -u $USER -x waybar > /dev/null; do sleep 0.1; done
    fi
    waybar & disown
fi

# 6. Notify Success
notify-send "Dynamic Theme" "Wallpaper: $CHOICE"
