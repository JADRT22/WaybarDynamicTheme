#!/usr/bin/env bash

# =============================================================================
# WAYBAR DYNAMIC THEME - INSTALLATION SCRIPT (v4.1)
# Description: Automates the setup of WaybarDynamicTheme, Wallust, and Hyprland.
# Author: JADRT22 (Fernando)
# =============================================================================

# --- PATH CONFIGURATION ---
# Resolve the repository from this script's location so setup.sh works from
# any directory (not only the repo root).
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/WaybarDynamicTheme"
WALLUST_TEMPLATES_DIR="$HOME/.config/wallust/templates"
HYPR_SCRIPTS_DIR="$HOME/.config/hypr/scripts"
LOCAL_BIN_DIR="$HOME/.local/bin"

# --- COLOR CODES ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo -e "   🚀 WaybarDynamicTheme - Installer"
echo -e "==========================================${NC}"

# --- 1. DEPENDENCY CHECK ---
echo -e "\n${YELLOW}[1/5] Checking dependencies...${NC}"
deps=("swww" "rofi" "waybar" "wallust" "notify-send")
missing_deps=0
for dep in "${deps[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        echo -e "${RED}✘ Error: '$dep' is not installed.${NC}"
        missing_deps=1
    else
        echo -e "${GREEN}✔ '$dep' found.${NC}"
    fi
done

if [ "$missing_deps" == "1" ]; then
    echo -e "${RED}\nPlease install missing dependencies before running this script.${NC}"
    exit 1
fi

# SwayNC is optional: the theme script degrades gracefully without it.
if command -v swaync >/dev/null 2>&1; then
    echo -e "${GREEN}✔ 'swaync' found (optional).${NC}"
else
    echo -e "${YELLOW}! 'swaync' not found - notification styling will be skipped.${NC}"
fi

# --- 2. CREATE DIRECTORIES ---
echo -e "\n${YELLOW}[2/5] Setting up directories...${NC}"
mkdir -p "$CONFIG_DIR"
mkdir -p "$WALLUST_TEMPLATES_DIR"
mkdir -p "$HYPR_SCRIPTS_DIR"
mkdir -p "$LOCAL_BIN_DIR"
echo -e "${GREEN}✔ Directories created at ~/.config/ and ~/.local/bin${NC}"

# --- 3. DEPLOY WALLUST TEMPLATES ---
echo -e "\n${YELLOW}[3/5] Deploying Wallust templates...${NC}"
templates=(
    "colors-cava" "colors-ghostty.conf" "colors-hyprland.conf"
    "colors-kitty.conf" "colors-swaync.css" "gtk-colors.template"
    "json.template" "rofi-colors.template" "waybar-colors.template"
)

for template in "${templates[@]}"; do
    if [ -f "$REPO_DIR/$template" ]; then
        ln -sf "$REPO_DIR/$template" "$WALLUST_TEMPLATES_DIR/$template"
        echo -e "${GREEN}✔ Linked: $template${NC}"
    else
        echo -e "${RED}✘ Warning: Template $template not found in $REPO_DIR.${NC}"
    fi
done

# --- 4. LINK UNIFIED SCRIPT ---
echo -e "\n${YELLOW}[4/5] Linking Unified Script...${NC}"
script="WaybarTheme.sh"
if [ -f "$REPO_DIR/scripts/$script" ]; then
    chmod +x "$REPO_DIR/scripts/$script"
    # Link to Hyprland scripts
    ln -sf "$REPO_DIR/scripts/$script" "$HYPR_SCRIPTS_DIR/$script"
    # Create convenient command links for backward compatibility
    ln -sf "$REPO_DIR/scripts/$script" "$HYPR_SCRIPTS_DIR/WaybarDynamicHub.sh"
    ln -sf "$REPO_DIR/scripts/$script" "$HYPR_SCRIPTS_DIR/Refresh.sh"
    echo -e "${GREEN}✔ Linked: scripts/$script -> $HYPR_SCRIPTS_DIR/$script${NC}"
    # Link a plain command name so it can be called without the full path
    ln -sf "$REPO_DIR/scripts/$script" "$LOCAL_BIN_DIR/$script"
    echo -e "${GREEN}✔ Linked: scripts/$script -> $LOCAL_BIN_DIR/$script${NC}"
    case ":$PATH:" in
        *":$LOCAL_BIN_DIR:"*) ;;
        *) echo -e "${YELLOW}  Note: ~/.local/bin is not in your PATH, call it with the full path or add it to PATH.${NC}" ;;
    esac
else
    echo -e "${RED}✘ Error: scripts/$script not found in $REPO_DIR.${NC}"
    exit 1
fi

# --- 5. WALLUST CONFIGURATION ---
echo -e "\n${YELLOW}[5/5] Wallust configuration...${NC}"
WALLUST_TOML="$HOME/.config/wallust/wallust.toml"
if [ -f "$WALLUST_TOML" ]; then
    echo -e "${YELLOW}! $WALLUST_TOML already exists, leaving untouched.${NC}"
elif [ -f "$REPO_DIR/wallust.toml.example" ]; then
    ln -sf "$REPO_DIR/wallust.toml.example" "$WALLUST_TOML"
    echo -e "${GREEN}✔ Linked: wallust.toml.example -> $WALLUST_TOML${NC}"
    echo -e "${YELLOW}  Edit it to match your own paths (it is a symlink to the repo file).${NC}"
else
    echo -e "${RED}✘ Warning: wallust.toml.example not found in $REPO_DIR.${NC}"
fi

# --- FINAL STEPS ---
echo -e "\n${BLUE}=========================================="
echo -e "   ✨ Installation Complete (v4.1)!"
echo -e "==========================================${NC}"
echo -e "Next steps:"
echo -e "1. Review '~/.config/wallust/wallust.toml' and adjust the template targets."
echo -e "2. Add keybinds in your Hyprland config (~/.config/hypr/UserConfigs/UserKeybinds.conf):"
echo -e "   ${YELLOW}bind = \$mainMod, G, exec, $HYPR_SCRIPTS_DIR/WaybarTheme.sh --switch${NC}"
echo -e "   ${YELLOW}bind = \$mainMod SHIFT, H, exec, $HYPR_SCRIPTS_DIR/WaybarTheme.sh --hub${NC}"
echo -e "3. Restore the last theme on login (Hyprland autostart):"
echo -e "   ${YELLOW}exec-once = $HYPR_SCRIPTS_DIR/WaybarTheme.sh --restore${NC}"
echo -e "   ${YELLOW}exec-once = swww-daemon${NC}"
echo -e "4. Select a wallpaper and enjoy your dynamic theme!"
echo -e "\nFollow the instructions in the README.md for more details."
