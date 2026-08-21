#!/bin/bash

export PATH="$HOME/.local/bin:$PATH"

# Caminho absoluto para a sua pasta de wallpapers
WALLPAPER_DIR=$1

# Intervalo em segundos (120s = 2 minutos)
INTERVAL=120

# Garante que a pasta de cache do awww existe
mkdir -p "$HOME/.cache/awww"

# Pequeno respiro para o compositor subir o daemon
sleep 2

while true; do
    # Pega dinamicamente apenas os nomes dos monitores ativos (ignora o eDP-1 se fechado)
    active_monitors=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')
    
    if [ -n "$active_monitors" ]; then
        num_monitors=$(echo "$active_monitors" | wc -w)
        
        # Seleciona um lote de imagens únicas e embaralhadas da pasta (uma para cada monitor ativo)
        images=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n "$num_monitors"))
        
        i=0
        for monitor in $active_monitors; do
            img="${images[$i]}"
            
            # Aplica uma imagem diferente para cada monitor com transição suave
            if [ -n "$img" ]; then
                awww img "$img" \
                    --outputs "$monitor" \
                    --transition-type grow \
                    --transition-pos 0.5,0.5 \
                    --transition-duration 2 \
                    --transition-fps 60
            fi
            i=$((i + 1))
        done
    fi
    
    # Aguarda o próximo ciclo de troca
    sleep "$INTERVAL"
done
