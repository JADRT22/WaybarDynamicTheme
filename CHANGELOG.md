# Changelog

All notable changes to the **WaybarDynamicTheme** project will be documented in this file.

## [v2.0.0] - 2026-02-20
### Added
- **Visual Previews (Thumbnails):** Rofi menu now displays image previews for each wallpaper before selection.
- **Rofi Theme Integration:** Added `rofi-colors.template` for full UI color synchronization.
- **GTK Support (Experimental):** Added `gtk-colors.template` for GTK3/GTK4 (Thunar, etc.) color injection.
- **Improved Notifications:** User-friendly `notify-send` alerts for theme status and completion.
- **Ghostty Terminal Support:** Automatic color sync for the Ghostty terminal.

### Changed
- **Architectural Shift:** Removed all Python scripts (`main.py`, `dynamic_theme.py`) in favor of direct **Wallust** integration.
- **Performance:** Optimized script execution with parallel process management and quiet mode.
- **Code Refactor:** Standardized code style and translated all internal documentation to English.
- **README Redesign:** Comprehensive installation guide and project overview.

### Fixed
- **Kitty Color Bug:** Fixed double inclusion of color files in `kitty.conf`.
- **Rofi Menu Formatting:** Cleaned up the list of wallpapers (removed absolute paths and redundant extensions).
- **Graceful Restart:** Improved `Refresh.sh` to handle Waybar symlinks and config file detection properly.

## [v1.0.0] - 2026-02-19
### Initial Release
- Basic dynamic color extraction via Python and Wallust.
- Simple wallpaper switching with SWWW.
- Basic Waybar color injection.

---
*Created by JADRT22 (Fernando) with AI assistance*
