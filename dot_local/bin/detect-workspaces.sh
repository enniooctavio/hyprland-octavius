#!/usr/bin/env bash

# Identifica os descritores dos monitores conectados atualmente
CONNECTED_MONITORS=$(hyprctl monitors)
DIR_HYPR="$HOME/.config/hypr"

if echo "$CONNECTED_MONITORS" | grep -q "AOC"; then
    ln -sf "$DIR_HYPR/workspaces-office.conf" "$DIR_HYPR/workspaces.conf"
elif echo "$CONNECTED_MONITORS" | grep -q "Acer"; then
    ln -sf "$DIR_HYPR/workspaces-home.conf" "$DIR_HYPR/workspaces.conf"
else
    # Fallback apenas para tela do notebook
    ln -sf "$DIR_HYPR/workspaces-office.conf" "$DIR_HYPR/workspaces.conf"
fi
