# Waybar Dynamic Theme & Layout Preservation

> [!IMPORTANT]
> **Disclaimer:** This project was built entirely with AI in about one hour for pure fun. It is NOT intended to be a serious or professional tool. Expect messy code, potential bugs, or "workaround" logic. I did this just for the "rice" (Linux customization) and to see what was possible in a single session!

This project automates wallpaper color extraction for Waybar while ensuring the user's **Layout** and **Style** choices are preserved.

## 🛠️ Requirements
- **Hyprland** (and `swww` for wallpapers)
- **Waybar**
- **Wallust** (v3.0+)
- **Python 3**
- **Rofi**
- **xdg-user-dirs** (Standard Linux tool for folder names)

## 📂 Project Structure
- `DynamicLayoutSwitcher.sh`: The main script to change wallpapers and colors.
- `Refresh.sh`: Restarts Waybar preserving the active layout and style.
- `dynamic_theme.py`: Python helper for extra color processing.
- `waybar-colors.template`: Wallust template for color variables.

## 🚀 Installation Guide (Step-by-Step)

### 1. Clone the repository
```bash
git clone https://github.com/JADRT22/WaybarDynamicTheme.git
cd WaybarDynamicTheme
```

### 2. Permissions
Ensure the scripts are executable:
```bash
chmod +x *.sh *.py
```

### 3. Setup Wallust Template
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

### 4. Integration
Link the scripts to your Hyprland scripts folder (e.g., `~/.config/hypr/scripts/`):
```bash
cp *.sh *.py ~/.config/hypr/scripts/
```

Add a keybind to your Hyprland config:
```hypr
bind = $mainMod, G, exec, ~/.config/hypr/scripts/DynamicLayoutSwitcher.sh
```

## 📂 Troubleshooting & Paths
- **Wallpaper Folder:** The script automatically looks for wallpapers in `$(xdg-user-dir PICTURES)/wallpapers`.
- **Dynamic Style:** Ensure your Waybar themes import the colors file:
  `@import "$HOME/.config/waybar/wallust/colors-waybar.css";`

---
*Enhanced with AI assistance on Feb 19, 2026*
