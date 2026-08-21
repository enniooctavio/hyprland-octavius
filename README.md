# 🚀 Hyprland Octavius

Um ecossistema completo, modular e nativo para o [Hyprland](https://hyprland.org/), focado em produtividade, gerenciamento inteligente de múltiplos monitores através de interface gráfica e uma estética cyberpunk refinada, priorizando a eficiência energética de notebooks.

## 🌌 Visão Geral
Este projeto centraliza todas as configurações do Hyprland em favor da sintaxe nativa `.conf`. Ele gerencia layouts complexos de múltiplos monitores de forma nativa, atalhos de navegação otimizados, e conta com um sistema inteligente de aplicação de wallpapers cinematográficos que fluem perfeitamente por várias telas.

## ✨ Funcionalidades Principais
* **Gerenciamento Visual de Monitores:** Utiliza o `nwg-displays` para configuração gráfica de múltiplos displays (portátil + externos), com suporte nativo a fallback automático do Hyprland.
* **Navegação Otimizada:** Atalhos refinados para movimento entre janelas (`SUPER + N`), workspaces invisíveis/scratchpads (`SUPER + S`) e ações de janela perfeitamente mapeadas.
* **Sistema Avançado de Wallpapers:** Scripts customizados (`setwall` e `cropwall`) que utilizam recortes cinematográficos ultrawide e fatiamento exato para que uma única imagem flua através de múltiplos monitores[cite: 7].
* **Waybar Modular e Estilizado:** Barra de status integrada com indicadores de CPU, Memória, Áudio, Rede e Bateria com caixas estilizadas em bordas neon.
* **Estabilidade e Bateria (Intel iGPU):** Configurado com *Damage Tracking* e *VFR (Variable Frame Rate)* ativos para garantir máxima autonomia de bateria em notebooks corporativos.
* **Interface Coesa:** Integração modular com Waybar, Rofi e regras estritas de opacidade por classe de aplicativo.

## 📦 Dependências e Pré-requisitos
Para o funcionamento pleno do Octavius, certifique-se de ter os seguintes pacotes instalados no seu sistema:
* `nwg-displays`: Interface gráfica para gerenciamento de monitores no Wayland.
* `swaybg`: Responsável por renderizar os papéis de parede por monitor.
* `imagemagick`: Utilizado pelo `cropwall` para os recortes cirúrgicos de imagens.
* `jq`: Necessário para ler e alinhar a ordem física dos monitores via JSON[cite: 7, 8].
* Pacotes centrais: `hypridle`, `hyprlock`, `waybar`, `rofi`, `wl-clipboard` e `cliphist`.

## 🚀 Instalação
O projeto conta com um instalador automatizado que cria pastas alvo, faz backup das configurações antigas, copia os assets de imagem e aplica links simbólicos de todos os binários e dotfiles[cite: 8].

1. Clone este repositório no seu diretório home[cite: 8]:
   ```bash
   git clone [https://github.com/SEU_USUARIO/hyprland-octavius.git](https://github.com/SEU_USUARIO/hyprland-octavius.git) ~/hyprland-octavius
