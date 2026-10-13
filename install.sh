#!/usr/bin/env bash
set -euo pipefail

echo "🚀 [Project Octavius] Instalando e sincronizando ecossistema..."

DIR_PROJETO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_CONFIG="$HOME/.config"
DIR_HYPR="$DIR_CONFIG/hypr"
DIR_BIN="$HOME/.local/bin"

# 1. Estrutura base de diretórios
mkdir -p "$DIR_CONFIG"
mkdir -p "$DIR_HYPR"
mkdir -p "$DIR_HYPR/workspace-profiles"
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
ln -sf "$DIR_PROJETO/dot_config/hypr/monitors-default.conf" "$DIR_HYPR/monitors-default.conf"
ln -sf "$DIR_PROJETO/dot_config/hypr/workspaces-default.conf" "$DIR_HYPR/workspaces-default.conf"
ln -sfn "$DIR_PROJETO/dot_config/hypr/scripts" "$DIR_HYPR/scripts"
ln -sfn "$DIR_PROJETO/dot_config/hypr/shaders" "$DIR_HYPR/shaders"

# Shared defaults contain no monitor identifiers. Keep local monitor/workspace
# profiles in ~/.config/hypr and never copy them from this repository.
if [[ ! -e "$DIR_HYPR/monitors.conf" ]]; then
    ln -sfn "$DIR_HYPR/monitors-default.conf" "$DIR_HYPR/monitors.conf"
fi
if [[ ! -e "$DIR_HYPR/workspaces.conf" ]]; then
    ln -sfn "$DIR_HYPR/workspaces-default.conf" "$DIR_HYPR/workspaces.conf"
fi
if [[ ! -e "$DIR_HYPR/monitor-profile-map.conf" ]]; then
    cp "$DIR_PROJETO/dot_config/hypr/monitor-profile-map.conf.example" \
        "$DIR_HYPR/monitor-profile-map.conf"
fi

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
    UDEV_RULE="/etc/udev/rules.d/50-bluetooth-wake.rules"
    if ! cmp -s "$DIR_PROJETO/system_fixes/50-bluetooth-wake.rules" \
        "$UDEV_RULE"; then
        echo "⚙️  Atualizando regra udev (requer sudo)..."
        sudo install -m 0644 \
            "$DIR_PROJETO/system_fixes/50-bluetooth-wake.rules" \
            "$UDEV_RULE"
        sudo udevadm control --reload-rules
        sudo udevadm trigger
    fi
fi

# 9. Reiniciar daemon de gestos
if command -v libinput-gestures-setup &>/dev/null; then
    libinput-gestures-setup restart || true
fi

# 10. Permite que Hyprlock leia o hash apenas para o usuário da sessão.
if [[ -e /etc/security/pin.pwdfile ]]; then
    PIN_ACL_USER="$(id -un)"
    if command -v setfacl &>/dev/null && command -v getfacl &>/dev/null; then
        PIN_ACL="$(getfacl -cp /etc/security/pin.pwdfile)"
        if ! grep -Fxq 'user::rw-' <<<"$PIN_ACL" ||
           ! grep -Fxq "user:$PIN_ACL_USER:r--" <<<"$PIN_ACL" ||
           ! grep -Fxq 'group::---' <<<"$PIN_ACL" ||
           ! grep -Fxq 'mask::r--' <<<"$PIN_ACL" ||
           ! grep -Fxq 'other::---' <<<"$PIN_ACL"; then
            echo "🔐 Permitindo leitura do PIN apenas para $PIN_ACL_USER..."
            sudo setfacl -m \
                "u::rw-,u:$PIN_ACL_USER:r--,g::---,m::r--,o::---" \
                /etc/security/pin.pwdfile
        fi
    else
        echo "⚠️  Instale 'acl' para habilitar PIN no Hyprlock com acesso restrito."
    fi
fi

if [[ ! -x /usr/libexec/hyprpolkitagent ]]; then
    echo "⚠️  Agente polkit ausente; instale o pacote 'hyprpolkitagent'."
fi

# 11. Ativa perfil local somente se já houver uma sessão Hyprland.
if command -v hyprctl &>/dev/null && hyprctl -j monitors all >/dev/null 2>&1; then
    "$DIR_BIN/detect-workspaces.sh" || true
fi

echo "✅ [Project Octavius] Deploy concluído com sucesso!"
