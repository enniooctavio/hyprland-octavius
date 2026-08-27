#!/usr/bin/env bash
set -e

echo "🚀 [Project Octavius] Instalando e sincronizando ecossistema..."

DIR_PROJETO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_CONFIG="$HOME/.config"
DIR_HYPR="$DIR_CONFIG/hypr"
DIR_BIN="$HOME/.local/bin"

# 1. Estrutura base de diretórios
mkdir -p "$DIR_CONFIG"
mkdir -p "$DIR_HYPR"
mkdir -p "$DIR_BIN"

# 2. Backup de segurança do hyprland.conf caso seja um arquivo real (não link)
if [ -f "$DIR_HYPR/hyprland.conf" ] && [ ! -L "$DIR_HYPR/hyprland.conf" ]; then
    mv "$DIR_HYPR/hyprland.conf" "$DIR_HYPR/hyprland.conf.bkp"
    echo "📦 Backup do hyprland.conf antigo realizado."
fi

# 3. Symlinks das configurações do Hyprland e subpastas
ln -sf "$DIR_PROJETO/dot_config/hypr/hyprland.conf" "$DIR_HYPR/hyprland.conf"
ln -sf "$DIR_PROJETO/dot_config/hypr/hypridle.conf" "$DIR_HYPR/hypridle.conf"
ln -sf "$DIR_PROJETO/dot_config/hypr/hyprlock.conf" "$DIR_HYPR/hyprlock.conf"
ln -sfn "$DIR_PROJETO/dot_config/hypr/scripts" "$DIR_HYPR/scripts"
ln -sfn "$DIR_PROJETO/dot_config/hypr/shaders" "$DIR_HYPR/shaders"

# 4. Symlinks dos apps visuais e de gestos
ln -sfn "$DIR_PROJETO/dot_config/waybar" "$DIR_CONFIG/waybar"
ln -sfn "$DIR_PROJETO/dot_config/rofi" "$DIR_CONFIG/rofi"
ln -sf "$DIR_PROJETO/dot_config/libinput-gestures.conf" "$DIR_CONFIG/libinput-gestures.conf"
ln -sfn "$DIR_PROJETO/dot_config/swaync" "$DIR_CONFIG/swaync"

# 5. Symlinks de todos os binários em dot_local/bin (dinâmico e à prova de novos scripts)
echo "🔗 Vinculando scripts executáveis em ~/.local/bin/..."
for script in "$DIR_PROJETO"/dot_local/bin/*; do
    if [ -f "$script" ]; then
        target="$DIR_BIN/$(basename "$script")"
        chmod +x "$script"
        ln -sf "$script" "$target"
        echo "   -> $(basename "$script")"
    fi
done

# 6. Copia wallpapers padrão para a pasta de Imagens
DIR_IMAGENS=${XDG_PICTURES_DIR:-$HOME/Imagens}
mkdir -p "$DIR_IMAGENS/Wallpapers"
if [ -d "$DIR_PROJETO/assets/wallpapers" ]; then
    cp -rn "$DIR_PROJETO/assets/wallpapers/"* "$DIR_IMAGENS/Wallpapers/" 2>/dev/null || true
    echo "🖼️  Wallpapers sincronizados em $DIR_IMAGENS/Wallpapers/"
fi

# 7. Permissões de execução internas
chmod -R +x "$DIR_PROJETO/dot_config/hypr/scripts/" 2>/dev/null || true

# 8. Regras de sistema udev (se existirem)
if [ -f "$DIR_PROJETO/system_fixes/50-bluetooth-wake.rules" ]; then
    echo "⚙️  Instalando regras udev (requer sudo)..."
    sudo cp "$DIR_PROJETO/system_fixes/50-bluetooth-wake.rules" /etc/udev/rules.d/
    sudo udevadm control --reload-rules && sudo udevadm trigger
fi

# 9. Reiniciar daemon de gestos
if command -v libinput-gestures-setup &>/dev/null; then
    libinput-gestures-setup restart || true
fi

echo "✅ [Project Octavius] Deploy concluído com sucesso!"
