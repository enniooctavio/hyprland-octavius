#!/bin/bash
echo "🚀 Instalando o ecossistema Hyprland Octavius (Versão Nativa .conf)..."

DIR_PROJETO="$HOME/hyprland-octavius"
DIR_HYPR="$HOME/.config/hypr"
DIR_BIN="$HOME/.local/bin"

# 1. Cria as pastas alvo no sistema (caso não existam)
mkdir -p "$DIR_HYPR/scripts"
mkdir -p "$DIR_HYPR/perfis"
mkdir -p "$DIR_BIN"

# 2. Transforma o hyprland.conf antigo em backup (por segurança)
if [ -f "$DIR_HYPR/hyprland.conf" ] && [ ! -L "$DIR_HYPR/hyprland.conf" ]; then
    mv "$DIR_HYPR/hyprland.conf" "$DIR_HYPR/hyprland.conf.bkp"
    echo "Backup do hyprland.conf antigo realizado."
fi

# 3. Cria os Links Simbólicos das Configurações do Hyprland
ln -sf "$DIR_PROJETO/dot_config/hypr/hyprland.conf" "$DIR_HYPR/hyprland.conf"
ln -sf "$DIR_PROJETO/dot_config/hypr/hypridle.conf" "$DIR_HYPR/hypridle.conf"
ln -sf "$DIR_PROJETO/dot_config/hypr/hyprlock.conf" "$DIR_HYPR/hyprlock.conf"

# 3.1. Cria o link simbólico da pasta de scripts internos do Hyprland
ln -sfn "$DIR_PROJETO/dot_config/hypr/scripts" "$DIR_HYPR/scripts"

# 4. Cria os Links Simbólicos das Pastas Visuais (Waybar e Rofi)
if [ -d "$DIR_PROJETO/dot_config/waybar" ]; then
    ln -sfn "$DIR_PROJETO/dot_config/waybar" "$HOME/.config/waybar"
fi
if [ -d "$DIR_PROJETO/dot_config/rofi" ]; then
    ln -sfn "$DIR_PROJETO/dot_config/rofi" "$HOME/.config/rofi"
fi

# 5. Cria os Links Simbólicos dos Binários (Scripts)
ln -sf "$DIR_PROJETO/dot_local/bin/auto-perfil" "$DIR_BIN/auto-perfil"
ln -sf "$DIR_PROJETO/dot_local/bin/setwall" "$DIR_BIN/setwall"
ln -sf "$DIR_PROJETO/dot_local/bin/cropwall" "$DIR_BIN/cropwall"
ln -sf "$DIR_PROJETO/dot_local/bin/cycle-ws" "$DIR_BIN/cycle-ws"
ln -sf "$DIR_PROJETO/dot_local/bin/power-menu" "$DIR_BIN/power-menu"
ln -sf "$DIR_PROJETO/dot_local/bin/toggle-desktop" "$DIR_BIN/toggle-desktop"

# 6. Copia os wallpapers padrão para a pasta de Imagens
DIR_IMAGENS=${XDG_PICTURES_DIR:-$HOME/Imagens}
mkdir -p "$DIR_IMAGENS/Wallpapers"
cp -rn "$DIR_PROJETO/assets/wallpapers/"* "$DIR_IMAGENS/Wallpapers/" 2>/dev/null
echo "Wallpapers padrão copiados para $DIR_IMAGENS/Wallpapers/"

# 7. Garante permissão de execução para todos os scripts
chmod +x "$DIR_PROJETO/dot_local/bin/"*
chmod +x "$DIR_PROJETO/dot_config/hypr/scripts/"*

echo "✅ Instalação concluída com sucesso! Ambiente nativo configurado."
