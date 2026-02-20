# 🌈 Waybar Dynamic Theme & Layout Preservation

> [!IMPORTANT]
> **Disclaimer:** This project was built entirely with AI in about one hour for pure fun. It is NOT intended to be a serious or professional tool. Expect messy code, potential bugs, or "workaround" logic. I did this just for the "rice" (Linux customization) and to see what was possible in a single session!

This project automates wallpaper color extraction for Waybar while ensuring the user's **Layout** and **Style** choices are preserved.

## 📺 Demonstration

### Dynamic Color Swapping
![Dynamic Colors](assets/dynamic-colors.gif)

### Layout and Style Preservation
| Layout Preservation | Style Variation |
| :---: | :---: |
| ![Layout Preservation](assets/layout-preservation.gif) | ![Style Variation](assets/style-variation.gif) |

## ✨ Features
- **Dynamic Color Extraction:** Uses Python and Wallust to generate themes based on the wallpaper.
- **Layout Preservation:** Maintains the active Waybar layout (e.g., Top, Bottom, Vertical) when changing colors.
- **Robust Error Handling:** Verifies dependencies and waits for daemons to be ready before applying changes.
- **Path Flexibility:** Easy-to-edit configuration variables at the top of each script.

## 🛠️ Requirements
- **Hyprland** (and `swww` for wallpapers)
- **Waybar**
- **Wallust** (v3.0+)
- **Python 3**
- **Rofi**
- **ImageMagick** (for color extraction via Python)

## 📂 Project Structure
- `DynamicLayoutSwitcher.sh`: Main script to change wallpapers and colors.
- `Refresh.sh`: Restarts Waybar while preserving the active layout and style.
- `dynamic_theme.py`: Helper Python script for extra color processing.
- `style/dynamic_minimal.css`: Base style that imports dynamic colors.
- `waybar-colors.template`: Wallust template for color variables.

## 🚀 Installation Guide

### 1. Clone the repository
```bash
git clone https://github.com/JADRT22/WaybarDynamicTheme.git
cd WaybarDynamicTheme
```

### 2. Setup Wallust Template
Copy the template to your Wallust config:
```bash
mkdir -p ~/.config/wallust/templates
cp waybar-colors.template ~/.config/wallust/templates/colors-waybar.css
```

Add this to your `~/.config/wallust/wallust.toml` under `[templates]`:
```toml
waybar.template = 'colors-waybar.css'
waybar.target = '~/.config/waybar/wallust/colors-waybar.css'
```

### 3. Hyprland Integration
Link the scripts to your Hyprland scripts folder (e.g., `~/.config/hypr/scripts/`):
```bash
cp *.sh *.py ~/.config/hypr/scripts/
mkdir -p ~/.config/waybar/style
cp style/*.css ~/.config/waybar/style/
```

Add a keybind to your Hyprland config:
```hypr
bind = $mainMod, G, exec, ~/.config/hypr/scripts/DynamicLayoutSwitcher.sh
```

## 📂 Troubleshooting
- **Wallpaper Folder:** The script looks for wallpapers in `$(xdg-user-dir PICTURES)/wallpapers` by default. This can be edited at the top of `DynamicLayoutSwitcher.sh`.
- **Dynamic Style:** Ensure your Waybar themes import the colors file:
  `@import url("/home/YOUR_USER/.config/waybar/wallust/colors-waybar.css");`

---
*Enhanced with AI assistance on Feb 19, 2026*
