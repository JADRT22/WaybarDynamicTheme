# Changelog

All notable changes to the **WaybarDynamicTheme** project will be documented in this file.

## [v4.1.0] - 2026-10-20
### Added
- **Restore on login:** new `--restore` mode that reapplies your last wallpaper and palette instantly at session start, without restarting Waybar.
- **Modern Waybar configs:** the script now detects and uses `config.jsonc` when your Waybar setup uses that filename, and falls back to `config`.
- **`SKIP_SEQUENCES` option:** set it to `1` in `~/.config/WaybarDynamicTheme/config.conf` to keep wallust from touching terminal appearances.
- **`wallust.toml.example`:** a ready-to-use configuration file with the correct template names, linked automatically by `setup.sh` when you don't have one yet.

### Changed
- **Wallust behavior:** terminal color sequences are now kept by default, so Kitty and Ghostty stay in sync. Users who preferred the old, colors-only behavior can set `SKIP_SEQUENCES=1`.
- **Setup script:** works from any directory, links the script into `~/.local/bin`, verifies `notify-send`, only warns about the optional `swaync`, and never overwrites an existing `wallust.toml`.

### Fixed
- **Wallpaper picker selection:** choosing a wallpaper with spaces in its name (or duplicate names in different folders) no longer opens the wrong image.
- **SwayNC reload:** the notification daemon now gets enough time to start before being reloaded.
- **Stability:** strict-mode guards mean pressing Escape in any menu, or a tool returning "nothing to kill", never closes the hub.
- **README:** the template name for Rofi now matches the real file (`rofi-colors.template`).

## [v4.0.0] - 2026-02-20
### Added
- **Major Architecture Upgrade:** Consistently unified all scripts into `WaybarTheme.sh`.
- **Premium Rofi Gallery:** Redesigned the wallpaper picker with a modern 3-column gallery layout and large thumbnails.
- **Enhanced Configuration:** Added "Full Config Example" to the README for easier setup.
- **Robustness:** Global version alignment and major bug fixes for system-wide synchronization.

### Changed
- **Security & Stability:** Added robust variable quoting and improved path handling to prevent errors with special characters or spaces.
- **Config Management:** Refactored `update_config` for more reliable persistence across reboots.

### Fixed
- Outdated version numbers in the Project Info dialog.
- Formatting issues in GitHub release notes.

## [v3.1.0] - 2026-02-20
### Added
- **Unified Master Script:** Merged all core logic into a single high-performance script: `WaybarTheme.sh`.
- **Command-Line Interface (CLI):** Support for direct task execution via flags: `--refresh`, `--switch`, and `--layout`.

## [v3.0.0] - 2026-02-20
### Added
- **Waybar Dynamic Hub:** A central Rofi-based management menu to control all theme features.
- **Bar Layout Switcher:** Instantaneously switch between over 40 Waybar layouts.
- **Deep Hyprland Sync:** Enabled dynamic window borders and shadows via Wallust.

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
