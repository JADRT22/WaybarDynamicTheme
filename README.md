# 🌈 Waybar Dynamic Theme & Layout Preservation

> [!IMPORTANT]
> **Disclaimer:** Este projeto foi construído inteiramente com IA em cerca de uma hora para pura diversão. Não se destina a ser uma ferramenta séria ou profissional. Espere código bagunçado, possíveis bugs ou lógica de "gambiarra". Fiz isso apenas para o "rice" (personalização do Linux) e para ver o que era possível em uma única sessão!

Este projeto automatiza a extração de cores de wallpapers para o Waybar enquanto garante que as escolhas de **Layout** e **Estilo** do usuário sejam preservadas.

## 📺 Demonstração

### Troca Dinâmica de Cores
![Dynamic Colors](assets/dynamic-colors.gif)

### Preservação de Layout e Estilos
| Preservação de Layout | Variação de Estilos |
| :---: | :---: |
| ![Layout Preservation](assets/layout-preservation.gif) | ![Style Variation](assets/style-variation.gif) |

## ✨ Funcionalidades
- **Extração Dinâmica de Cores:** Usa Python e Wallust para gerar temas baseados no wallpaper.
- **Preservação de Layout:** Mantém o layout ativo da Waybar (ex: Superior, Inferior, Vertical) ao mudar de cor.
- **Tratamento de Erros Robusto:** Verifica dependências e aguarda daemons estarem prontos antes de aplicar mudanças.
- **Flexibilidade de Caminhos:** Variáveis de configuração fáceis de editar no topo de cada script.

## 🛠️ Requisitos
- **Hyprland** (e `swww` para wallpapers)
- **Waybar**
- **Wallust** (v3.0+)
- **Python 3**
- **Rofi**
- **ImageMagick** (para extração de cores via Python)

## 📂 Estrutura do Projeto
- `DynamicLayoutSwitcher.sh`: Script principal para mudar wallpapers e cores.
- `Refresh.sh`: Reinicia o Waybar preservando o layout e estilo ativos.
- `dynamic_theme.py`: Script Python auxiliar para processamento extra de cores.
- `style/dynamic_minimal.css`: Estilo base que importa as cores dinâmicas.
- `waybar-colors.template`: Template do Wallust para variáveis de cor.

## 🚀 Guia de Instalação

### 1. Clonar o repositório
```bash
git clone https://github.com/JADRT22/WaybarDynamicTheme.git
cd WaybarDynamicTheme
```

### 2. Configurar o Template do Wallust
Copie o template para sua configuração do Wallust:
```bash
mkdir -p ~/.config/wallust/templates
cp waybar-colors.template ~/.config/wallust/templates/colors-waybar.css
```

Adicione isto ao seu `~/.config/wallust/wallust.toml` sob `[templates]`:
```toml
waybar.template = 'colors-waybar.css'
waybar.target = '~/.config/waybar/wallust/colors-waybar.css'
```

### 3. Integração com o Hyprland
Vincule os scripts à sua pasta de scripts do Hyprland (ex: `~/.config/hypr/scripts/`):
```bash
cp *.sh *.py ~/.config/hypr/scripts/
mkdir -p ~/.config/waybar/style
cp style/*.css ~/.config/waybar/style/
```

Adicione um atalho à sua configuração do Hyprland:
```hypr
bind = $mainMod, G, exec, ~/.config/hypr/scripts/DynamicLayoutSwitcher.sh
```

## 📂 Resolução de Problemas
- **Pasta de Wallpapers:** O script procura por wallpapers em `$(xdg-user-dir PICTURES)/wallpapers` por padrão. Isso pode ser editado no topo do `DynamicLayoutSwitcher.sh`.
- **Estilo Dinâmico:** Certifique-se de que seus temas da Waybar importam o arquivo de cores:
  `@import url("/home/SEU_USUARIO/.config/waybar/wallust/colors-waybar.css");`

---
*Aprimorado com assistência de IA em 19 de fev de 2026*
