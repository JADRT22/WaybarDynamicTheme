#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts para atualizar waybar, rofi, swaync, wallust com maior flexibilidade

# =============================================================================
# CONFIGURAÇÃO DE CAMINHOS
# =============================================================================
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
WAYBAR_CONFIG_FILE="$WAYBAR_CONFIG_DIR/config"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
UserScripts="$HOME/.config/hypr/UserScripts"

# =============================================================================
# 1. MATAR PROCESSOS RODANDO
# =============================================================================
# Lista de processos a serem reiniciados
_ps=(waybar rofi swaync ags)

for _prs in "${_ps[@]}"; do
  if pidof "${_prs}" >/dev/null; then
    pkill "${_prs}"
  fi
done

# Matar instâncias extras do cava (módulo de áudio da Waybar)
if command -v killall >/dev/null; then
    killall cava 2>/dev/null
fi

# Pequena pausa para garantir o encerramento gracioso
sleep 0.5

# Matar na força se ainda estiverem vivos
for _prs in "${_ps[@]}"; do
  if pidof "${_prs}" >/dev/null; then
    killall -9 "${_prs}" 2>/dev/null
  fi
done

# =============================================================================
# 2. REINICIAR WAYBAR COM O CONFIG ATUAL
# =============================================================================
if [ -L "$WAYBAR_CONFIG_FILE" ]; then
    CURRENT_CONFIG=$(readlink -f "$WAYBAR_CONFIG_FILE")
    # Tenta iniciar a Waybar com o arquivo resolvido
    if [ -f "$CURRENT_CONFIG" ]; then
        waybar -c "$CURRENT_CONFIG" &
    else
        echo "Aviso: Arquivo vinculado não encontrado: $CURRENT_CONFIG. Usando config padrão."
        waybar &
    fi
else
    # Caso não seja um link simbólico, tenta o arquivo padrão
    waybar &
fi

# =============================================================================
# 3. REINICIAR OUTROS COMPONENTES
# =============================================================================

# Reiniciar swaync (notificações) se instalado
if command -v swaync >/dev/null; then
    swaync >/dev/null 2>&1 &
fi

# Recarregar configurações do swaync se o cliente existir
if command -v swaync-client >/dev/null; then
    swaync-client --reload-config 2>/dev/null
fi

# =============================================================================
# 4. EXECUTAR USER SCRIPTS (EXTENSÕES)
# =============================================================================
if [ -f "${UserScripts}/RainbowBorders.sh" ]; then
  "${UserScripts}/RainbowBorders.sh" &
fi

exit 0
