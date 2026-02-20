#!/usr/bin/env bash

# =============================================================================
# CONFIGURAÇÃO DE CAMINHOS (EDITE SE NECESSÁRIO)
# =============================================================================
WALLPAPER_DIR="$(xdg-user-dir PICTURES)/wallpapers"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
PYTHON_SCRIPT="$SCRIPTS_DIR/dynamic_theme.py"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
ROFI_THEME_DIR="$HOME/.config/rofi/themes"

# =============================================================================
# FUNÇÕES DE UTILIDADE
# =============================================================================
check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        notify-send "Erro: Dependência Ausente" "A ferramenta '$1' não foi encontrada. Por favor, instale-a."
        exit 1
    fi
}

# Verificar dependências essenciais
check_command "swww"
check_command "rofi"
check_command "python3"
check_command "magick"

# =============================================================================
# 1. ESCOLHER WALLPAPER
# =============================================================================
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Erro" "Diretório de wallpapers não encontrado: $WALLPAPER_DIR"
    exit 1
fi

mapfile -t PICS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \))

if [ ${#PICS[@]} -eq 0 ]; then
    notify-send "Erro" "Nenhum wallpaper encontrado em $WALLPAPER_DIR"
    exit 1
fi

CHOICE=$(printf "%s\n" "${PICS[@]##*/}" | rofi -dmenu -i -p "Selecione o Wallpaper: ")

if [ -z "$CHOICE" ]; then
    exit 0
fi

SELECTED_WALL=$(find "$WALLPAPER_DIR" -iname "$CHOICE" -print -quit)

if [ ! -f "$SELECTED_WALL" ]; then
    notify-send "Erro" "O arquivo selecionado não foi encontrado."
    exit 1
fi

# =============================================================================
# 2. DEFINIR WALLPAPER COM SWWW
# =============================================================================
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    while ! swww query > /dev/null 2>&1; do
        sleep 0.1
    done
fi

swww img "$SELECTED_WALL" --transition-type grow --transition-pos 0.5,0.5 --transition-fps 60 --transition-duration 2

# =============================================================================
# 3. EXTRAIR CORES E APLICAR TEMAS
# =============================================================================

# Python para cores customizadas
if [ -f "$PYTHON_SCRIPT" ]; then
    python3 "$PYTHON_SCRIPT" "$SELECTED_WALL"
else
    echo "Aviso: Script Python não encontrado em $PYTHON_SCRIPT"
fi

# Wallust para integração sistêmica
if command -v wallust > /dev/null; then
    wallust run -s "$SELECTED_WALL"
fi

# =============================================================================
# 4. REINICIAR WAYBAR COM SEGURANÇA
# =============================================================================
REFRESH_SCRIPT="$SCRIPTS_DIR/Refresh.sh"

if [ -f "$REFRESH_SCRIPT" ]; then
    "$REFRESH_SCRIPT"
else
    # Fallback caso o Refresh.sh não exista
    pkill waybar
    while pgrep -x waybar > /dev/null; do sleep 0.1; done
    waybar & disown
fi

# =============================================================================
# 5. NOTIFICAÇÃO FINAL
# =============================================================================
notify-send "Tema Dinâmico" "Wallpaper aplicado: $CHOICE"
