# 🚀 Hyprland Octavius

Um ecossistema modular, performático e nativo para o [Hyprland](https://hyprland.org/)[cite: 13], projetado para workflows corporativos de alta produtividade, gerenciamento avançado de múltiplos monitores em estações dock e estética Cyberpunk refinada com foco em eficiência energética e estabilidade[cite: 13].

---

## 🌌 Visão Geral

O **Project Octavius** centraliza e versiona todas as configurações do Hyprland em sua sintaxe declarativa nativa `.conf`[cite: 13]. O ambiente conta com detecção dinâmica de monitores via descritores físicos de hardware[cite: 13], navegação espacial de janelas, central de controle e notificações deslizante, pop-ups OSD modernos e suporte a gestos multi-touch no touchpad.

---

## ✨ Funcionalidades Principais

* **Overview Espacial por Monitor (`Hyprspace`):** Visão geral de janelas abertas filtrada exclusivamente para o display em foco, eliminando poluição visual de múltiplos monitores (`SUPER + W` ou gesto de 3 dedos para cima)[cite: 4, 5].
* **Central de Notificações & Controle (`SwayNC`):** Painel lateral deslizante com histórico de alertas, controle de Não Perturbe (DND), controles multimídia MPRIS e integração com a Waybar (`SUPER + SHIFT + D`)[cite: 9, 11].
* **Regras de Janela Modernizadas (Hyprland 0.56+):**
  * **Picture-in-Picture:** Janelas flutuantes com ancoragem automática no canto inferior direito (`pin on` + `size 25% 25%`).
  * **Diálogos de Sistema:** Janelas de seleção de arquivos, `pavucontrol` e autenticação com comportamento flutuante automático (`float on`).
  * **Isolamento de Screen Share (`xwaylandvideobridge`):** Ocultação transparente e isolamento de buffers virtuais para evitar telas pretas em transmissões no Slack, Google Meet e Discord.
* **Gestos Nativos no Touchpad (`libinput-gestures`):** Deslize de 3 dedos para navegação contínua entre workspaces (`swipe left/right`), scratchpad rápido (`swipe down`) e ativação do overview (`swipe up`)[cite: 4].
* **Autenticação Híbrida e Resiliente:** Suporte unificado para senha corporativa (JumpCloud), PIN local via `pam_pwdfile` e biometria rápida via `pam_fprintd` no `hyprlock`, `sudo` e `polkit`[cite: 2].
* **OSD Gráfico e Controle de Mídia (`SwayOSD`):** Feedback visual flutuante na tela para ajustes de volume, brilho e caps lock[cite: 3, 5].
* **Efeitos de Foco & Shaders:** Animações dinâmicas de foco (`hyprfocus`)[cite: 3, 5, 13] e suporte a shaders pós-processamento GLSL (efeitos CRT, ruído VHS e aberração cromática).
* **Gerenciamento Visual de Displays (`nwg-displays`):** Mapeamento de telas portátil + dock por descritor físico (`desc:`), garantindo persistência sem dependência de nomes de portas de vídeo[cite: 13].
* **Sistema Avançado de Wallpapers (`setwall` / `cropwall`):** Fatiamento cirúrgico de papéis de parede panorâmicos que fluem sem quebras entre múltiplos monitores[cite: 13].
* **Scratchpad Terminal Invisível:** Instância persistente do Kitty pronta para chamadas imediatas em workspace especial (`SUPER + S`)[cite: 3, 5, 13].

---

## 📦 Dependências e Pré-requisitos

Para o funcionamento pleno do ecossistema, certifique-se de instalar as dependências no sistema base[cite: 13]:

```bash
sudo apt update && sudo apt install -y \
  hyprland \
  waybar \
  rofi \
  sway-notification-center \
  libinput-gestures \
  brightnessctl \
  swaybg \
  imagemagick \
  jq \
  wl-clipboard \
  cliphist \
  libpam-pwdfile \
  whois \
  nwg-displays
```

### Utilitários Complementares
* **`SwayOSD`**: Servidor e cliente de pop-ups visuais Wayland para teclado e brilho[cite: 3, 5].
* **`fcitx5`**: Gerenciador de input para composição de acentuação e cedilha (`ç`)[cite: 3, 5].

---

## 🛠️ Compilação do Hyprspace (Hyprland 0.56+)

Devido à migração do pipeline gráfico para Aquamarine e modularização de bibliotecas (`hyprutils`), o Hyprspace deve ser compilado a partir da branch com correções de compatibilidade (PR #238):

```bash
# 1. Clonar o repositório e buscar a branch do PR #238
cd ~/.local/share
git clone [https://github.com/KZDKM/Hyprspace.git](https://github.com/KZDKM/Hyprspace.git)
cd Hyprspace
git fetch origin pull/238/head:pr-238
git checkout pr-238

# 2. Compilar contra os cabeçalhos do Hyprland
PKG_CONFIG_PATH="/var/cache/hyprpm/$USER/headersRoot/share/pkgconfig:$PKG_CONFIG_PATH" make all
```

*O binário `Hyprspace.so` resultante será carregado automaticamente pelo `hyprland.conf` durante a inicialização (`exec-once = hyprctl plugin load ...`)[cite: 3, 5].*

---

## 🚀 Instalação e Deploy

O deploy é gerenciado pelo script idempotente `install.sh`, responsável por vincular as configurações via symlinks, ajustar permissões e configurar regras de hardware[cite: 6]:

```bash
# 1. Clonar o repositório
git clone [https://github.com/enniooctavio/hyprland-octavius.git](https://github.com/enniooctavio/hyprland-octavius.git) ~/hyprland-octavius

# 2. Executar o instalador
cd ~/hyprland-octavius
chmod +x install.sh
./install.sh
```

### Configuração dos Monitores (`nwg-displays`)
Abra o `nwg-displays` no menu de aplicativos e mapeie o layout físico dos displays[cite: 13]. Marque a opção **"Usar descrição"** para que a configuração seja persistida por ID único do hardware em `~/.config/hypr/monitors.conf` e `~/.config/hypr/workspaces.conf`[cite: 13].

---

## ⌨️ Principais Atalhos de Teclado

| Atalho | Ação |
| :--- | :--- |
| `SUPER + W` | Alternar Visão Geral / Overview (`Hyprspace`) |
| `SUPER + SHIFT + D` | Alternar Central de Notificações (`SwayNC`) |
| `SUPER + ESPAÇO` | Lançador de Aplicativos (`Rofi`)[cite: 3, 5] |
| `SUPER + .` | Menu de Emojis (`Rofimoji`)[cite: 3, 5] |
| `SUPER + ` ` ` (code:49) | Terminal Principal (`Kitty`)[cite: 3, 5] |
| `SUPER + S` | Alternar Terminal Scratchpad[cite: 3, 5, 13] |
| `SUPER + CTRL + S` | Mover Janela Atual para o Scratchpad[cite: 3, 5] |
| `SUPER + SHIFT + S` | Captura de Tela Interativa (`Grim` + `Slurp` + `Swappy`)[cite: 3, 5] |
| `SUPER + SHIFT + V` | Histórico da Área de Transferência (`Cliphist`)[cite: 3, 5] |
| `SUPER + N` / `SUPER + SHIFT + N` | Ciclar Workspaces / Mover Janela Ciclando[cite: 3, 5] |
| `SUPER + L` | Bloqueio de Tela (`Hyprlock`)[cite: 3, 5] |
| `SUPER + D` | Ocultar/Mostrar Janelas (`toggle-desktop`)[cite: 3, 5] |
| `SUPER + ESC` | Menu de Energia / Logout (`power-menu`)[cite: 3, 5] |
