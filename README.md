# 🚀 Hyprland Octavius

Um ecossistema completo, modular e nativo para o [Hyprland](https://hyprland.org/), focado em produtividade, gerenciamento inteligente de múltiplos monitores através de interface gráfica e uma estética cyberpunk refinada, priorizando a eficiência energética de notebooks.

## 🌌 Visão Geral
Este projeto centraliza todas as configurações do Hyprland em favor da sintaxe nativa `.conf`. Ele gerencia layouts complexos de múltiplos monitores de forma nativa através do `nwg-displays`, atalhos de navegação otimizados, e conta com um sistema inteligente de aplicação de wallpapers cinematográficos que fluem perfeitamente por várias telas[cite: 7, 13].

## ✨ Funcionalidades Principais
* **Gerenciamento Visual de Monitores e Workspaces:** Utiliza o `nwg-displays` para configuração gráfica de múltiplos displays (portátil + externos) utilizando descrições físicas de hardware (`desc:`), garantindo portabilidade entre diferentes ambientes (casa/trabalho) sem conflitos de portas físicas. Os workspaces são rigidamente mapeados e salvos de forma independente em `workspaces.conf`.
* **Plugins e Extensões via `hyprpm`:** O ecossistema gerencia nativamente plugins de experiência visual avançada através do *Hyprland Plugin Manager* (`hyprpm`)[cite: 10, 12]:
  * **`hyprfocus`**: Adiciona animações dinâmicas de foco (efeito *shrink* e *flash* ao alternar janelas)[cite: 10, 12].
  * **`hyprexpo`**: Oferece a visão geral dos workspaces (estilo Exposé, acionado por `SUPER + W`)[cite: 10, 12].
* **Navegação Otimizada:** Atalhos refinados para movimento entre janelas (`SUPER + N`), workspaces invisíveis/scratchpads (`SUPER + S`) e ações de janela perfeitamente mapeadas.
* **Sistema Avançado de Wallpapers:** Scripts customizados (`setwall` e `cropwall`) que utilizam recortes cinematográficos ultrawide e fatiamento exato para que uma única imagem flua através de múltiplos monitores[cite: 7, 13].
* **Waybar Modular e Estilizado:** Barra de status integrada com indicadores de CPU, Memória, Áudio, Rede e Bateria com caixas estilizadas em bordas neon.
* **Estabilidade e Bateria (Intel iGPU):** Configurado com *Damage Tracking* e *VFR (Variable Frame Rate)* ativos para garantir máxima autonomia de bateria em notebooks corporativos.
* **Interface Coesa:** Integração modular com Waybar, Rofi e regras estritas de opacidade por classe de aplicativo.

## 📦 Dependências e Pré-requisitos
Para o funcionamento pleno do Octavius, certifique-se de ter os seguintes pacotes instalados no seu sistema:
* `nwg-displays`: Interface gráfica para gerenciamento de monitores e workspaces no Wayland.
* `swaybg`: Responsável por renderizar os papéis de parede por monitor[cite: 7, 13].
* `imagemagick`: Utilizado pelo `cropwall` para os recortes cirúrgicos de imagens[cite: 7, 13].
* `jq`: Necessário para ler e alinhar a ordem física dos monitores via JSON[cite: 7, 8, 13].
* Pacotes centrais: `hypridle`, `hyprlock`, `waybar`, `rofi`, `wl-clipboard` e `cliphist`.

## ⚙️ Configuração Inicial do Ambiente (Monitores e Plugins)
Como o Octavius prioriza a portabilidade e separa as configurações de hardware por máquina, siga estes passos após a instalação:

1. **Configuração dos Monitores (`nwg-displays`):**
   Abra a interface gráfica do `nwg-displays` para mapear suas telas. Lembre-se de ativar a caixinha **"Usar descrição"** para ancorar as configurações ao modelo e número de série exatos do hardware. Isso gerará automaticamente os arquivos locais `monitors.conf` e `workspaces.conf` em `~/.config/hypr/`.
2. **Habilitação dos Plugins (`hyprpm`):**
   Os plugins `hyprfocus` e `hyprexpo` declarados no `hyprland.conf` dependem do gerenciador oficial. Certifique-se de que eles estão habilitados e compilados através do `hyprpm`[cite: 10, 12] no primeiro boot.

## 🚀 Instalação
O projeto conta com um instalador automatizado que cria pastas alvo, faz backup das configurações antigas, copia os assets de imagem e aplica links simbólicos de todos os binários e dotfiles[cite: 8, 13].

1. Clone este repositório no seu diretório home[cite: 8, 13]:
   ```bash
   git clone [https://github.com/enniooctavio/hyprland-octavius.git](https://github.com/enniooctavio/hyprland-octavius.git) ~/hyprland-octavius
