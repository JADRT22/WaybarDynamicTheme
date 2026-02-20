#!/usr/bin/env python3
import os
import subprocess
import sys
import re

def get_dominant_colors(image_path):
    # Usa ImageMagick para extrair as 5 cores mais comuns
    cmd = f"magick '{image_path}' -resize 100x100 -colors 5 -format '%c' histogram:info:-"
    result = subprocess.check_output(cmd, shell=True).decode()
    
    # Regex para extrair hex codes
    hex_colors = re.findall(r'#[0-9A-Fa-f]{6}', result)
    return hex_colors

def luminance(hex_color):
    hex_color = hex_color.lstrip('#')
    r, g, b = tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
    return 0.299*r + 0.587*g + 0.114*b

def generate_themes(primary, secondary, wallpaper_path):
    # Cores derivadas
    bg = "#1a1b26" # Fundo escuro padrão
    fg = "#ffffff" # Texto claro padrão
    
    # Se a cor primária for muito escura, ajusta o fundo
    if luminance(primary) < 40:
        bg = primary
        primary = secondary 
    
    # Salva as cores em um arquivo que ambos (Waybar e Rofi) podem ler
    # Vamos usar um caminho absoluto nos templates para evitar erro de "arquivo não encontrado"
    
    waybar_color_file = os.path.expanduser("~/.config/waybar/dynamic_colors.css")
    with open(waybar_color_file, "w") as f:
        f.write(f"@define-color primary {primary};\n")
        f.write(f"@define-color secondary {secondary};\n")
        f.write(f"@define-color background {bg};\n")
        f.write(f"@define-color foreground {fg};\n")
        
    rofi_color_file = os.path.expanduser("~/.config/rofi/dynamic_colors.rasi")
    with open(rofi_color_file, "w") as f:
        f.write(f"* {{\n    primary: {primary};\n    secondary: {secondary};\n    background: {bg}ee;\n    foreground: {fg};\n}}\n")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)
        
    wallpaper = sys.argv[1]
    colors = get_dominant_colors(wallpaper)
    
    if len(colors) >= 2:
        generate_themes(colors[0], colors[1], wallpaper)
