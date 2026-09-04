#!/bin/bash

# Se passarmos um número junto com o comando (ex: 3), ele espera esses segundos
if [ -n "$1" ]; then
    sleep $1
fi

# Tira a foto da tela inteira congelando o momento
grim /tmp/full_screen.png

# Chama o slurp para marcar a área
AREA=$(slurp -f "%wx%h+%x+%y")

# Se apertar ESC, cancela
if [ -z "$AREA" ]; then
    exit 1
fi

# Recorta e manda para o Swappy
magick /tmp/full_screen.png -crop "$AREA" /tmp/screenshot_active.png
swappy -f /tmp/screenshot_active.png
