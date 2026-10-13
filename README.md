# Hyprland Octavius

Configurações e scripts para um ambiente Hyprland com atalhos próprios,
Waybar, Rofi, SwayNC, gestos, controle de mídia e suporte a múltiplos monitores.
O repositório contém defaults compartilháveis; layouts e identificadores físicos
dos monitores ficam na configuração local de cada máquina.

## Funcionalidades

- Perfis de monitores/workspaces selecionados localmente por eventos de
  hotplug, abertura da tampa e retomada da suspensão.
- Waybar, Rofi e SwayNC com tema cyberpunk.
- Hyprspace para overview e Hyprfocus para animações de foco, como plugins
  externos do Hyprland.
- Gestos via `libinput-gestures`, OSD via SwayOSD e clipboard via Cliphist.
- Scratchpad, grupos de janelas, captura de área, menus de áudio/energia e
  ferramentas de wallpaper.
- Regras udev opcionais para o adaptador Bluetooth listado em
  `system_fixes/50-bluetooth-wake.rules`.

## Dependências

Em Ubuntu, instale os pacotes usados pela configuração:

```bash
sudo apt update
sudo apt install \
  hyprland hyprlock hypridle hyprpolkitagent \
  waybar rofi sway-notification-center swayosd \
  libinput-gestures fcitx5 gnome-keyring \
  kitty nautilus \
  grim slurp swappy wl-clipboard cliphist \
  swaybg imagemagick jq \
  network-manager qalculate-gtk pipewire-pulse wireplumber acl
```

O pacote `hyprland` pode exigir um repositório compatível com a versão usada.
`nwg-displays` é opcional e pode ajudar a gerar as configurações locais de
monitores. `pactl` e `wpctl` precisam estar disponíveis para os controles de
áudio. SwayNC é iniciado pela unidade de usuário, após importar o ambiente
Wayland da sessão.

Os plugins Hyprspace e Hyprfocus são instalados separadamente; veja
[Plugins](#plugins). Wallpapers e a ferramenta pessoal `k8s-switcher` não são
distribuídos neste repositório.

## Instalação

```bash
git clone https://github.com/enniooctavio/hyprland-octavius.git \
  ~/hyprland-octavius
cd ~/hyprland-octavius
./install.sh
```

O instalador cria os links das configurações e scripts, instala a regra udev
quando presente e concede leitura do hash PIN via ACL somente ao usuário atual,
para que o Hyprlock (que não roda como root) consiga validar o PIN. Ele não
instala pacotes, não cria PIN e não substitui arquivos em `/etc/pam.d`; assim,
as regras de autenticação corporativas permanecem sob gestão da empresa.

### Perfis locais de monitores

Os arquivos com descrições/seriais dos monitores não fazem parte do repositório.
Crie-os localmente:

- `~/.config/hypr/monitors-<perfil>.conf`
- `~/.config/hypr/workspace-profiles/<perfil>.conf`
- `~/.config/hypr/monitor-profile-map.conf`

O mapa usa uma linha por perfil, no formato
`nome-do-perfil|regex-da-descrição-do-monitor`. Por exemplo, se o mapa contiver
`mesa-a|Fabricante Modelo`, o detector procura
`monitors-mesa-a.conf` e `workspace-profiles/mesa-a.conf`. Comece pelo modelo
sem dados pessoais em `dot_config/hypr/monitor-profile-map.conf.example`.

Use `nwg-displays` ou `hyprctl monitors all` para descobrir as descrições e
criar os arquivos locais. O detector espera uma lista estável de monitores,
recarrega o Hyprland apenas quando muda o perfil e mantém Waybar/SwayNC ativos
para evitar destruir/recriar superfícies durante o hotplug. O listener de
eventos também detecta monitores conectados ou removidos; a retomada da
suspensão dispara uma nova detecção.

Sem mapa ou perfil correspondente, o ambiente usa defaults genéricos e a regra
de monitor `preferred, auto` de `hyprland.conf`.

## Plugins

### Hyprfocus pelo HyprPM

```bash
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprfocus
hyprpm update
hyprpm reload
```

Se o Hyprland informar que os plugins foram preparados para o próximo início,
reinicie a sessão gráfica para carregar builds compatíveis com a ABI atual.

### Hyprspace

O plugin é carregado a partir de
`~/.local/share/Hyprspace/Hyprspace.so`. O checkout usado neste ambiente é a
branch de compatibilidade PR #238:

```bash
mkdir -p ~/.local/share
git clone https://github.com/KZDKM/Hyprspace.git \
  ~/.local/share/Hyprspace
cd ~/.local/share/Hyprspace
git fetch origin pull/238/head:pr-238
git checkout pr-238
PKG_CONFIG_PATH="/var/cache/hyprpm/$USER/headersRoot/share/pkgconfig:${PKG_CONFIG_PATH:-}" \
  make all
```

Recompile os plugins após atualizar o Hyprland. Eles são binários externos e
não são versionados no projeto.

## Autenticação

`system_fixes/pam/` contém exemplos locais opcionais de PAM para PIN/biometria.
Eles não são aplicados pelo instalador: revise-os com a administração da
máquina antes de qualquer uso, pois políticas corporativas são externas a este
projeto. Para que `pam_pwdfile` funcione no Hyprlock, conceda leitura do arquivo
somente à conta da sessão (o Hyprlock não roda como root):

```bash
sudo setfacl -m \
  "u::rw-,u:$(id -un):r--,g::---,m::r--,o::---" \
  /etc/security/pin.pwdfile
getfacl -cp /etc/security/pin.pwdfile
```

O serviço `fprintd` também precisa estar habilitado para biometria.

## Atalhos principais

| Atalho | Ação |
| --- | --- |
| `SUPER + W` | Overview do Hyprspace |
| `SUPER + SHIFT + D` | Alternar central do SwayNC |
| `SUPER + SPACE` | Lançador de aplicativos (Rofi) |
| `SUPER + Q` | Menu de emojis (Rofimoji, se instalado) |
| `SUPER + grave` | Terminal (tecla `code:49`) |
| `SUPER + S` | Alternar scratchpad |
| `SUPER + CTRL + S` | Enviar janela ao scratchpad |
| `SUPER + SHIFT + S` | Captura de área (Grim + Slurp + Swappy) |
| `SUPER + SHIFT + V` | Histórico do clipboard |
| `SUPER + N` / `SUPER + SHIFT + N` | Ciclar / mover workspace no grupo do monitor |
| `SUPER + L` | Bloquear tela (Hyprlock) |
| `SUPER + D` | Ocultar/restaurar workspaces (toggle-desktop) |
| `SUPER + ESC` | Menu de energia |
| `SUPER + U` | Executar `~/.local/bin/k8s-switcher` (opcional) |

`SUPER + .` e `SUPER + ,` enviam `End` e `Home` à janela ativa; não são o
atalho do Rofimoji.

## Wallpapers e utilitários

- `setwall <triplo|duplo|mono|slide|video> <nome> [ext]` cria uma configuração
  local de inicialização do wallpaper.
- `cropwall <duplo|triplo> <arquivo> <nome-base>` fatia a imagem; o script
  atualmente remove o arquivo de origem após o corte.
- `audio-menu` é chamado pelos controles de áudio da Waybar.
- `rofi-wifi` pode ser executado manualmente; não possui atalho padrão.

Os arquivos de imagem/vídeo são fornecidos pelo usuário e ficam fora do Git.
