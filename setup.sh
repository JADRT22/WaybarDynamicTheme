#!/usr/bin/env bash

# =============================================================================
# WAYBAR DYNAMIC THEME - INSTALLATION SCRIPT (v3.3)
# Description: Automates the setup of WaybarDynamicTheme, Wallust, and Hyprland.
# Author: JADRT22 (Fernando)
# =============================================================================

# --- PATH CONFIGURATION ---
REPO_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config/WaybarDynamicTheme"
WALLUST_TEMPLATES_DIR="$HOME/.config/wallust/templates"
HYPR_SCRIPTS_DIR="$HOME/.config/hypr/scripts"

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
echo -e "\n${YELLOW}[1/4] Checking dependencies...${NC}"
deps=("swww" "rofi" "waybar" "wallust")
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

# --- 2. CREATE DIRECTORIES ---
echo -e "\n${YELLOW}[2/4] Setting up directories...${NC}"
mkdir -p "$CONFIG_DIR"
mkdir -p "$WALLUST_TEMPLATES_DIR"
mkdir -p "$HYPR_SCRIPTS_DIR"
echo -e "${GREEN}✔ Directories created at ~/.config/${NC}"

# --- 3. DEPLOY WALLUST TEMPLATES ---
echo -e "\n${YELLOW}[3/4] Deploying Wallust templates...${NC}"
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
        echo -e "${RED}✘ Warning: Template $template not found in current directory.${NC}"
    fi
done

# --- 4. LINK UNIFIED SCRIPT ---
echo -e "\n${YELLOW}[4/4] Linking Unified Script...${NC}"
script="WaybarTheme.sh"
if [ -f "$REPO_DIR/$script" ]; then
    chmod +x "$REPO_DIR/$script"
    # Link to Hyprland scripts
    ln -sf "$REPO_DIR/$script" "$HYPR_SCRIPTS_DIR/$script"
    # Create convenient command links for backward compatibility
    ln -sf "$REPO_DIR/$script" "$HYPR_SCRIPTS_DIR/WaybarDynamicHub.sh"
    ln -sf "$REPO_DIR/$script" "$HYPR_SCRIPTS_DIR/Refresh.sh"
    echo -e "${GREEN}✔ Linked: $script -> $HYPR_SCRIPTS_DIR/$script${NC}"
else
    echo -e "${RED}✘ Error: $script not found. Run this script from the repository root.${NC}"
    exit 1
fi

# --- FINAL STEPS ---
echo -e "\n${BLUE}=========================================="
echo -e "   ✨ Installation Complete (v3.3)!"
echo -e "==========================================${NC}"
echo -e "Next steps:"
echo -e "1. Update your '~/.config/wallust/wallust.toml' to use the new templates."
echo -e "2. Add keybinds in your Hyprland config (~/.config/hypr/UserConfigs/UserKeybinds.conf):"
echo -e "   ${YELLOW}bind = \$mainMod, G, exec, $HYPR_SCRIPTS_DIR/WaybarTheme.sh --switch${NC}"
echo -e "   ${YELLOW}bind = \$mainMod SHIFT, H, exec, $HYPR_SCRIPTS_DIR/WaybarTheme.sh --hub${NC}"
echo -e "3. Select a wallpaper and enjoy your dynamic theme!"
echo -e "\nFollow the instructions in the README.md for more details."
