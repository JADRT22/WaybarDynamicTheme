# 🌈 Waybar Dynamic Theme & Layout Preservation

> [!IMPORTANT]
> **AI-Powered & Community Driven:** This project was built entirely using AI to solve a personal customization challenge. I am now sharing it with the community! Please note that as an AI-assisted project, updates may occasionally introduce bugs, but I am committed to its serious development.

Automate your Hyprland aesthetic with dynamic color extraction and seamless layout preservation.

## 📖 Overview
**Waybar Dynamic Theme** is a comprehensive customization suite designed for Hyprland users. It synchronizes your entire system's color palette with your wallpaper using **Wallust**, while uniquely ensuring that your Waybar layouts and styles remain intact during the transition.

Whether you switch wallpapers or change your bar's physical layout, this project ensures a cohesive, beautiful, and functional desktop experience.

## ✨ Key Features
- **󱄄 Theme Management Hub:** A centralized Rofi-based interface to control wallpapers, bar layouts, and animations.
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
Add a keybind to your Hyprland configuration to access the Hub:
```hypr
bind = $mainMod, G, exec, ~/.config/hypr/scripts/WaybarDynamicHub.sh
```

## 📂 Architecture
- `WaybarDynamicHub.sh`: The main control center.
- `DynamicLayoutSwitcher.sh`: Handles wallpaper selection and color generation.
- `Refresh.sh`: Gracefully restarts system components and reloads GTK themes.
- `setup.sh`: Streamlined installation and environment setup.

---
*Developed by JADRT22 - Optimized for Hyprland*
