# 🌈 Waybar Dynamic Theme & Layout Preservation

> [!NOTE]
> **Project Status:** This project began as a fun AI-driven experiment in a single session. However, due to its potential and personal use, I am now evolving it into a more serious tool for Linux customization. Please keep in mind that much of the core logic was AI-assisted and development happens in my spare time as it is not my primary focus. Expect continuous improvements, but also the occasional "experimental" quirk!

This project automates wallpaper color extraction for Waybar, Rofi, and Terminals (Kitty/Ghostty) while ensuring the user's **Layout** and **Style** choices are preserved.

## 📺 Demonstration

### Dynamic Color Swapping
![Dynamic Colors](assets/dynamic-colors.gif)

### Layout and Style Preservation
| Layout Preservation | Style Variation |
| :---: | :---: |
| ![Layout Preservation](assets/layout-preservation.gif) | ![Style Variation](assets/style-variation.gif) |

## ✨ Features
- **Dynamic Color Extraction:** Uses **Wallust** (v3.0+) to generate themes based on the wallpaper.
- **Terminal Sync:** Automatically updates colors for **Kitty** and **Ghostty**.
- **UI Sync:** Updates **Waybar** and **Rofi** styles dynamically.
- **Layout Preservation:** Maintains the active Waybar layout (e.g., Top, Bottom, Vertical) when changing colors.
- **Robust Error Handling:** Verifies dependencies and waits for daemons to be ready before applying changes.

## 🛠️ Requirements
- **Hyprland** (and `swww` for wallpapers)
- **Waybar**
- **Wallust** (v3.0+)
- **Rofi**

## 📂 Project Structure
- `DynamicLayoutSwitcher.sh`: Main script to change wallpapers and colors via Rofi menu.
- `Refresh.sh`: Restarts Waybar while preserving the active layout and style.
- `waybar-colors.template`: Wallust template for Waybar color variables.
- `rofi-colors.template`: Wallust template for Rofi theme variables.

## 🚀 Installation Guide

### 1. Clone the repository
```bash
git clone https://github.com/JADRT22/WaybarDynamicTheme.git
cd WaybarDynamicTheme
```

### 2. Setup Wallust Templates
Copy the templates to your Wallust config:
```bash
mkdir -p ~/.config/wallust/templates
cp *.template ~/.config/wallust/templates/
```

Add this to your `~/.config/wallust/wallust.toml` under `[templates]`:
```toml
[templates]
waybar.template = 'waybar-colors.template'
waybar.target = '~/.config/waybar/wallust/colors-waybar.css'

rofi.template = 'rofi-colors.template'
rofi.target = '~/.config/rofi/wallust/colors-rofi.rasi'

kitty.template = 'colors-kitty.conf' # Ensure you have this template
kitty.target = '~/.config/kitty/kitty-themes/01-Wallust.conf'
```

### 3. Hyprland Integration
Link the scripts to your Hyprland scripts folder:
```bash
cp *.sh ~/.config/hypr/scripts/
```

Add a keybind to your Hyprland config:
```hypr
bind = $mainMod, G, exec, ~/.config/hypr/scripts/DynamicLayoutSwitcher.sh
```

---
*Enhanced with AI assistance on Feb 20, 2026*
