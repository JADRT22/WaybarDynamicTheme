# 🌈 Waybar Dynamic Theme & Layout Preservation (v3.0)

> [!IMPORTANT]
> **AI-Powered & Community Driven:** This project was built using AI to solve a personal customization challenge. I am now sharing it with the community! This version 3.0 is a major leap forward, introducing a central management hub and deeper system integration.

This project automates wallpaper color extraction for **Waybar**, **Hyprland**, **Rofi**, **Terminals (Kitty/Ghostty)**, and **GTK Apps** while ensuring the user's **Layout** and **Style** choices are preserved.

## 📺 Demonstration

### Dynamic Color Swapping
![Dynamic Colors](assets/dynamic-colors.gif)

### Layout and Style Preservation
| Bar Layout Switcher | GTK & Hyprland Sync |
| :---: | :---: |
| ![Layout Preservation](assets/layout-preservation.gif) | ![Style Variation](assets/style-variation.gif) |

## ✨ Features (v3.0)
- **󱄄 Central Theme Hub:** A dedicated Rofi-based menu to manage all theme aspects.
- **󰕮 Bar Layout Switcher:** Instantaneously switch between multiple Waybar layouts while keeping the current wallpaper colors.
- **󰵚 Transition Animations:** Choose from 6 different SWWW transition effects (Grow, Wipe, Wave, etc.) directly from the Hub.
- **󰸉 Visual Wallpaper Picker:** Browse and select wallpapers with thumbnails via Rofi.
- **🎨 Deep System Sync:** 
  - **Hyprland:** Dynamic window borders and shadows.
  - **GTK 3.0/4.0:** Real-time color updates for apps like Thunar and Nautilus.
  - **Terminals:** Support for Kitty and Ghostty.
  - **Rofi & SwayNC:** Fully themed notification center and menus.
- **⚙️ Config Persistence:** Saves your last wallpaper and bar layout choices.

## 🛠️ Requirements
- **Hyprland** (and `swww` for wallpapers)
- **Waybar**
- **Wallust** (v3.0+)
- **Rofi**
- **Gsettings** (for GTK theme reloading)

## 🚀 Easy Installation Guide

### 1. Clone the repository
```bash
git clone https://github.com/JADRT22/WaybarDynamicTheme.git
cd WaybarDynamicTheme
```

### 2. Run the Installer
```bash
chmod +x setup.sh
./setup.sh
```
*This script links all templates to `~/.config/wallust/templates/` and scripts to `~/.config/hypr/scripts/`.*

### 3. Wallust Templates Setup
Add this to your `~/.config/wallust/wallust.toml` under `[templates]`:
```toml
[templates]
cava.template = 'colors-cava'
cava.target = '~/.config/cava/config'

hypr.template = 'colors-hyprland.conf'
hypr.target = '~/.config/hypr/wallust/wallust-hyprland.conf'

rofi.template = 'colors-rofi.rasi'
rofi.target = '~/.config/rofi/wallust/colors-rofi.rasi'

waybar.template = 'colors-waybar.css'
waybar.target = '~/.config/waybar/wallust/colors-waybar.css'

kitty.template = 'colors-kitty.conf'
kitty.target = '~/.config/kitty/kitty-themes/01-Wallust.conf'

ghostty.template = 'colors-ghostty.conf'
ghostty.target = '~/.config/ghostty/wallust.conf'

gtk3.template = 'gtk-colors.template'
gtk3.target = '~/.config/gtk-3.0/colors.css'

gtk4.template = 'gtk-colors.template'
gtk4.target = '~/.config/gtk-4.0/colors.css'
```

### 4. Hyprland Keybind
Add this keybind to your Hyprland configuration (`~/.config/hypr/hyprland.conf`):
```hypr
bind = $mainMod, G, exec, ~/.config/hypr/scripts/WaybarDynamicHub.sh
```

## 📂 Project Structure
- `WaybarDynamicHub.sh`: Main management menu.
- `DynamicLayoutSwitcher.sh`: Core script for wallpaper selection and color application.
- `Refresh.sh`: Gracefully restarts UI components and reloads GTK CSS.
- `setup.sh`: Automated installation script.
- `*.template`: Pre-configured Wallust templates for various system components.

---
*Developed by JADRT22 - Enhanced with AI assistance on Feb 20, 2026*
