# Changelog

All notable changes to the **WaybarDynamicTheme** project will be documented in this file.

## [v3.3.0] - 2026-02-20
### Added
- **Premium Rofi Previews:** Redesigned the wallpaper picker with a 3-column gallery layout and large thumbnails.
- **Enhanced Configuration:** Added "Full Config Example" to the README for easier setup.
- **Improved Metadata:** Updated internal versioning to v3.3 across all scripts and UI components.

### Changed
- **Security & Stability:** Added robust variable quoting and improved path handling to prevent errors with special characters or spaces.
- **Config Management:** Refactored `update_config` for more reliable persistence across reboots.
- **Refresh Logic:** Improved Waybar restart logic to handle symlinks more gracefully.

### Fixed
- **Version Mismatch:** Fixed "Project Info" showing outdated version numbers.
- **GTK Refreshing:** Corrected a bug where GTK theme reloading could fail on some environments.

## [v3.1.0] - 2026-02-20
### Added
- **Unified Master Script:** Merged all core logic into a single high-performance script: `WaybarTheme.sh`.
- **Command-Line Interface (CLI):** Support for direct task execution via flags: `--refresh`, `--switch`, and `--layout`.
- **Backward Compatibility:** `setup.sh` now creates symlinks for legacy script names (`Refresh.sh`, `WaybarDynamicHub.sh`), preventing breakage of existing user keybinds.

### Changed
- **Architecture Cleanup:** Deleted redundant legacy scripts to maintain a clean and professional repository structure.
- **Improved Installation:** Enhanced `setup.sh` with robust symlinking and centralized script management.
- **Workflow Efficiency:** Internal Hub functions now call local code blocks instead of separate files, resulting in faster execution.

## [v3.0.0] - 2026-02-20
### Added
- **Waybar Dynamic Hub:** A central Rofi-based management menu (`WaybarDynamicHub.sh`) to control all theme features.
- **Bar Layout Switcher:** Instantaneously switch between over 40 Waybar layouts while preserving current wallpaper colors.
- **Automated Installer:** New `setup.sh` script for dependency checking, directory creation, and automatic linking of templates/scripts.
- **Deep Hyprland Sync:** Enabled dynamic window borders and shadows via Wallust (`colors-hyprland.conf`).
- **Real-time GTK Sync:** Added automatic GTK 3.0/4.0 theme reloading in `Refresh.sh` (using `gsettings`).
- **New Templates:** Added official Wallust templates for **Cava**, **SwayNC**, and **Ghostty**.
- **Visual Improvements:** Added a transition animation selector with 6 premium SWWW effects (Grow, Wipe, Wave, etc.).
- **Persistence:** The system now saves the `LAST_WALLPAPER` and `WAYBAR_LAYOUT` to a dedicated config file.

### Changed
- **Code Optimization:** Refactored `DynamicLayoutSwitcher.sh` and `Refresh.sh` for better performance and error handling.
- **Language:** All internal comments and user-facing messages in the Hub are now professionally translated to English for global reach.
- **Documentation:** Completely redesigned the `README.md` to focus on the new installation method and Hub features.

### Fixed
- **GTK Refreshing:** Solved the issue where open GTK windows wouldn't update colors until restarted.
- **Config Management:** Implemented a robust `update_config` function to prevent configuration file corruption.

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
