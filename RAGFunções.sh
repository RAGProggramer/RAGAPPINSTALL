#! /usr/bin/env bash
# shellcheck source=/dev/null

#-----------------------------------------| Váriaveis|-------------------------------------------------#
export DIR="$HOME/.cache/RAGlog";


# Set error code variable
export ERROR_CODE=2

declare -A NAVEGADORES=(
    ["edge-dev"]="microsoft-edge-dev-bin"
    ["edge-stable"]="microsoft-edge-stable-bin"
    ["chrome"]="google-chrome"
    ["firefox"]="firefox"
)

declare -A DRIVERS_GRAFIC_INSTAL=(
    ["AMD"]="lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader"
    ["INTEL"]="lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader"
    ["NVIDIA"]="nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader"
)

PAC=(
    base-devel 
    git
)

VERMELHO='\e[1;91m';
VERDE='\e[1;92m';
SEM_COR='\e[0m';
GREEN='\033[0;32m'
RESET='\033[0m'

#------------------------------------------| Testes/Atualização |------------------------------------------------#

atualizarEInstalarPacotes() {
  local CODIGO_ERRO=2
  local pacotes_com_falha=()

  if ! ping -c 1 8.8.8.8 -q &>/dev/null; then
    echo -e "${VERMELHO}[ERRO] - Seu computador não tem conexão com a internet.${SEM_COR}"
    return 1
  else
    echo -e "${VERDE}[INFO] - Conexão com a internet funcionando normalmente.${SEM_COR}"
  fi

  echo -e "${VERDE}[INFO] - Atualizando pacotes Pacman e YAY...${SEM_COR}"
  sudo pacman -Syu --noconfirm || { echo -e "${VERMELHO}[ERRO] - Falha ao atualizar os pacotes Pacman.${SEM_COR}"; return 1; }
  yay -Syu --noconfirm || { echo -e "${VERMELHO}[ERRO] - Falha ao atualizar os pacotes YAY.${SEM_COR}"; return 1; }

  PAC=("pacote1" "pacote2" "pacote3")  # Adicione aqui a lista de pacotes que você deseja instalar

  for programa in "${PAC[@]}"; do
    if ! pacman -Qq "$programa" &>/dev/null; then
      echo -e "${VERDE}[INFO] - Instalando $programa... ${SEM_COR}"
      sudo pacman -S "$programa" --noconfirm || { echo -e "${VERMELHO}[ERRO] - Falha ao instalar o pacote $programa.${SEM_COR}"; pacotes_com_falha+=("$programa"); }
    else
      echo -e "${VERDE}[INFO] - O pacote $programa já está instalado.${SEM_COR}"
    fi
  done

  if [ ${#pacotes_com_falha[@]} -gt 0 ]; then
    echo -e "${VERMELHO}[ERRO] - Falha ao instalar os seguintes pacotes: ${pacotes_com_falha[*]}.${SEM_COR}"
    return 1
  fi

  echo -e "${VERDE}[INFO] - Todos os pacotes foram instalados ou já estão presentes.${SEM_COR}"
  return 0
}


#-------------------------------------------| Funções |-----------------------------------------------#
cabecalho ( ) {
echo "                                                                                                                       ";
echo "    ██████╗  █████╗  ██████╗     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗          █████╗ ██████╗ ██████╗     ";
echo "    ██╔══██╗██╔══██╗██╔════╝     ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║         ██╔══██╗██╔══██╗██╔══██╗    ";
echo "    ██████╔╝███████║██║  ███╗    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║         ███████║██████╔╝██████╔╝    ";
echo "    ██╔══██╗██╔══██║██║   ██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║         ██╔══██║██╔═══╝ ██╔═══╝     ";
echo "    ██║  ██║██║  ██║╚██████╔╝    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗    ██║  ██║██║     ██║         ";
echo "    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═╝╚═╝     ╚═╝         ";
echo "                                                                                                                       ";
}

# Função para mostrar o efeito de carregamento
show_loading() {
    local message=$1
    local spin_chars="/-\|"

    echo -n "$message "
    for ((i = 0; i < 15; i++)); do
        echo -n "${spin_chars:i%4:1}"
        sleep 0.1
        echo -ne "\b"
    done
    echo " Concluído!"
}

instalar_paru() {
    cd "$DIR"
    if [ -f "$DIR/paru" ]; then
        echo -e "${VERDE}[INFO] - O arquivo paru já existe.${SEM_COR}"
    else
        echo -e "${VERDE}[INFO] - Instalando gerenciador de pacotes paru...${SEM_COR}"
        show_loading "Clonando repositório"
        git clone https://aur.archlinux.org/paru.git
        cd paru;
        show_loading "Compilando e instalando"
        makepkg -si
    fi
}

instalar_yay() {
    cd "$DIR"
    if [ -f "$DIR/yay" ]; then
        echo -e "${VERDE}[INFO] - O arquivo yay já existe.${SEM_COR}"
    else
        echo -e "${VERDE}[INFO] - Instalando gerenciador de pacotes yay...${SEM_COR}"
        show_loading "Clonando repositório"
        git clone https://aur.archlinux.org/yay.git
        cd yay
        show_loading "Compilando e instalando"
        makepkg -si
    fi
}



modificarPacmanConf() {
    # Etapa 1: Adicionar a seção [chaotic-aur]
    if ! grep -q '^\[chaotic-aur\]' /etc/pacman.conf; then
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
        echo -e "${VERDE}[SUCESSO] - Adicionada a seção [chaotic-aur].${RESET}"
    else
        echo -e "${VERMELHO}[INFO] - A seção [chaotic-aur] já existe.${RESET}"
    fi

    # Etapa 2: Remover os comentários da seção [multilib] com include
    if sudo grep -q '^\s*#\[multilib\]' /etc/pacman.conf; then
        sudo sed -i '/^\s*#\[multilib\]$/,/^\s*# include=\/etc\/pacman\.d\/mirrorlist$/ s/^#//' /etc/pacman.conf
        echo -e "${VERDE}[SUCESSO] - Comentários removidos da seção [multilib].${RESET}"
    else
        echo -e "${VERMELHO}[INFO] - A seção [multilib] já está descomentada.${RESET}"
    fi
}

#essa função  adiciona o repitorio chaotic-aur
ADDrepoChaotic () {
    echo -e "${VERDE}[INFO] - Adicionando Repositorios e Mirros do Chaotic.${SEM_COR}";
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
# Executar a função
    modificarPacmanConf
}
#essa função verifica se o diretorio log/downloads do nosso script funciona ou existe
verifDirExit () {
    DIR="seu_diretorio_aqui"

    # Verifica se o diretório já existe
    if [[ -d "$DIR" ]]; then
        echo -e "${GREEN}[INFO] - O diretório $DIR já existe.${RESET}"
    else
        # Chama a função de animação de carregamento
        show_loading "Criando diretório $DIR"

        # Cria o diretório
        mkdir -p "$DIR"

        # Exibe uma mensagem de conclusão
        echo -e "${GREEN}[INFO] - Diretório $DIR criado com sucesso!${RESET}"
    fi
}

driversGraficos() {
    echo "Escolha a opção que corresponde ao seu hardware:"
    echo "1 - AMD"
    echo "2 - INTEL"
    echo "3 - NVIDIA"
    echo "q - Sair"

    read -rp "Opção: " opcao

    case $opcao in
        1)
            instalar_pacotes ${DRIVERS_GRAFIC_INSTAL["AMD"]}
            ;;
        2)
            instalar_pacotes ${DRIVERS_GRAFIC_INSTAL["INTEL"]}
            ;;
        3)
            instalar_pacotes ${DRIVERS_GRAFIC_INSTAL["NVIDIA"]}
            ;;
        q)
            echo "Saindo..."
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            ;;
    esac
}

criarchavegpg() {
    echo -e "${VERDE}[INFO] - Criando chave GPG do Usuário...${SEM_COR}";
    
    # Pedir informações ao usuário
    read -p "Tamanho da chave (em bits): " chave_tamanho
    read -p "Comentário para a chave: " chave_comentario
    read -p "Prazo de validade da chave (em dias, deixe em branco para não definir prazo): " chave_prazo

    # Gerar a chave GPG
    gpg --batch --full-generate-key <<EOF
        Key-Type: RSA
        Key-Length: $chave_tamanho
        Subkey-Type: RSA
        Subkey-Length: $chave_tamanho
        Name-Real: $USER
        Comment: $chave_comentario
        $([ -n "$chave_prazo" ] && echo "Expire-Date: +$chave_prazo")
        %commit
EOF

    # Exibir mensagem com o ID da chave gerada
    echo -e "\n${VERDE}[INFO] - Chave GPG criada com o ID abaixo:${SEM_COR}"
    gpg --list-keys --keyid-format LONG "$USER"
}

# Chamar a função para iniciar o processo de instalação

zsheplugins(){
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${VERDE}[INFO] - Instalando o OH MY ZSH...${SEM_COR}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
  else
    echo -e "${VERDE}[INFO] - OH MY ZSH já está instalado.${SEM_COR}"
  fi

  # Verifica e instala o plugin zsh-autosuggestions
  if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
    echo -e "${VERDE}[INFO] - Instalando o plugin zsh-autosuggestions...${SEM_COR}"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
  else
    echo -e "${VERDE}[INFO] - O plugin zsh-autosuggestions já está instalado.${SEM_COR}"
  fi

  # Verifica e instala o plugin zsh-syntax-highlighting
  if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
    echo -e "${VERDE}[INFO] - Instalando o plugin zsh-syntax-highlighting...${SEM_COR}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
  else
    echo -e "${VERDE}[INFO] - O plugin zsh-syntax-highlighting já está instalado.${SEM_COR}"
  fi
}


grubtheme() {
echo -e "${VERDE}[INFO] - Instalando theme dedsec para o grub...${SEM_COR}"; 
cd "$DIR";
if [ -f "$DIR/dedsec-grub-theme" ]; then
    echo -e "${VERDE}[INFO] - O arquivo já existe."
else
git clone --depth 1 https://gitlab.com/VandalByte/dedsec-grub-theme.git && cd dedsec-grub-theme;
sudo python3 dedsec-theme.py --install;
fi

}

ativaservicos(){
    echo -e "${VERDE}[INFO] - ativando alguns serviçoes essenciais e reiniciando o sistema.${SEM_COR}"
    sudo systemctl enable NetworkManager sddm bluetooth.service;
}


installnavegador() {
    echo "---------------------------------------------"
    echo "|        Escolha o seu Navegador           |"
    echo "---------------------------------------------"
    echo "Opções:"
    i=1
    for nome_navegador in "${!NAVEGADORES[@]}"; do
        echo "$i - $nome_navegador"
        ((i++))
    done

    echo "q - Sair"
    
    read -rp "Opção: " opcao

    case $opcao in
        [1-4])
            nome_navegador="${!NAVEGADORES[@]}"
            navegador_selecionado=${nome_navegador[opcao-1]}
            pacote=${NAVEGADORES[$navegador_selecionado]}

            if ! yay -Q | grep -q "$pacote"; then
                echo "[INFO] - Instalando o $navegador_selecionado..."
                yay -S "$pacote" --noconfirm
                echo "[INFO] - $navegador_selecionado instalado com sucesso!"
            else
                echo "[INFO] - O pacote $navegador_selecionado já está instalado."
            fi
            ;;
        "q")
            echo "Saindo do menu."
            ;;
        *)
            echo "Opção inválida. Saindo do menu."
            ;;
    esac
}