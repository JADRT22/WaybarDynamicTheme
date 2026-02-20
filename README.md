# 🌈 WaybarDynamicTheme

[![GitHub Release](https://img.shields.io/github/v/release/JADRT22/WaybarDynamicTheme?style=flat-square&color=BC8AD1)](https://github.com/JADRT22/WaybarDynamicTheme/releases)
[![License](https://img.shields.io/github/license/JADRT22/WaybarDynamicTheme?style=flat-square&color=8AB4D1)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/JADRT22/WaybarDynamicTheme?style=flat-square&color=D1BD8A)](https://github.com/JADRT22/WaybarDynamicTheme/stargazers)

**Automatic dynamic theme for Waybar based on the current wallpaper, with intelligent layout and style preservation on Hyprland.**

> [!IMPORTANT]
> **AI-Powered & Community Driven:** This project was built entirely using AI to solve a personal customization challenge. I am now sharing it with the community! Please note that as an AI-assisted project, updates may occasionally introduce bugs, but I am committed to its serious development.

---

## 📺 Demonstration

### Dynamic Color Swapping
![Dynamic Colors](assets/dynamic-colors.gif)

### Layout and Style Preservation
| Bar Layout Switcher | GTK & Hyprland Sync |
| :---: | :---: |
| ![Layout Preservation](assets/layout-preservation.gif) | ![Style Variation](assets/style-variation.gif) |

---

## ✨ Key Features
- **󱄄 Unified Management Hub:** A single script control center to manage wallpapers, bar layouts, and animations.
- **󰕮 Bar Layout Preservation:** Switch between multiple Waybar configurations (top, bottom, vertical, etc.) without losing your dynamic color theme.
- **󰸉 Visual Wallpaper Picker:** Browse your wallpaper collection with high-quality thumbnails and premium transition effects via SWWW.
- **🎨 Full System Synchronization:**
  - **Hyprland:** Dynamic window borders, active colors, and shadows.
  - **Waybar & Rofi:** Fully themed bars and menus based on wallpaper tones.
  - **GTK 3/4:** Real-time CSS injection for apps like Thunar, Nautilus, and others.
  - **Terminals:** Automatic color syncing for Kitty and Ghostty.
  - **SwayNC & Cava:** Themed notifications and audio visualizers.
- **⚙️ Intelligent Persistence:** Automatically saves and reapplies your last chosen wallpaper and layout.

## 🚀 Getting Started

### 1. Installation
Clone the repository and run the automated setup script to link all templates and scripts to your configuration folders:
```bash
git clone https://github.com/JADRT22/WaybarDynamicTheme.git
cd WaybarDynamicTheme
chmod +x setup.sh
./setup.sh
```

### 2. Wallust Configuration
Ensure your `~/.config/wallust/wallust.toml` includes the provided templates to enable full system syncing. Refer to the project files for the complete template list.

### 3. Usage
Add these keybinds to your Hyprland configuration (`~/.config/hypr/UserConfigs/UserKeybinds.conf`):
```hypr
# Direct wallpaper switcher (Visual Picker)
bind = $mainMod, G, exec, ~/.config/hypr/scripts/WaybarTheme.sh --switch

# Full Management Hub (Layouts, Transitions, etc.)
bind = $mainMod SHIFT, H, exec, ~/.config/hypr/scripts/WaybarTheme.sh --hub

# Optional: Direct UI refresh
bind = $mainMod, R, exec, ~/.config/hypr/scripts/WaybarTheme.sh --refresh
```

## 📂 Architecture
- `scripts/WaybarTheme.sh`: The unified script that handles all tasks (Refresh, Wallpaper Switcher, Layout Selector, and Hub).
- `setup.sh`: Streamlined installation and environment setup.
- `*.template`: Wallust templates for various system components.

## 📝 Full Config Example (`wallust.toml`)
```toml
backend = "kmeans"
color_space = "labmixed"
palette = "dark16"

[templates]
cava.template = 'colors-cava'
cava.target = '~/.config/cava/config'

hypr.template = 'colors-hyprland.conf'
hypr.target = '~/.config/hypr/wallust/wallust-hyprland.conf'

rofi.template = 'rofi-colors.rasi'
rofi.target = '~/.config/rofi/wallust/colors-rofi.rasi'

waybar.template = 'waybar-colors.template'
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

---
*Developed by JADRT22 - Optimized for Hyprland*
