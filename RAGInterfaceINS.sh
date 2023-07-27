#! /usr/bin/env bash
# shellcheck source=/dev/null

source "RAGFunções.sh";

KDE_APP_INSTALL=(
    wget
    nano
    plasma-desktop
    plasma-wayland-session
    plasma-nm 
    plasma-framework
    ffmpegthumbnailer
    ffmpegthumbs 
    plasma-pa
    kate
    gwenview
    kscreen
    powerdevil 
    noto-fonts-emoji 
    sddm 
    tilix 
    dolphin 
    dolphin-plugins 
    spectacle 
    plasma-integration 
    plasma-workspace 
    kded 
    kwayland 
    kwayland-integration 
    systemsettings 
    plasma-workspace-wallpapers  
    ntfs-3g 
    ark 
    ffmpeg 
    gst-plugins-ugly 
    gst-plugins-good 
    gst-plugins-base 
    gst-plugins-bad 
    gst-libav 
    gstreamer 
    btrfs-progs 
    kio-gdrive 
    neofetch 
    htop 
    ark 
    grub-customizer 
    gufw 
    fwupd 
    xorg-server 
    xorg-xinit 
    xorg-apps 
    mesa
    zsh 
    zsh-completions
    base-devel 
    git
    plasma-framework 
    gst-libav 
    base-devel   
    qt5-webchannel 
    vulkan-headers 
    pulseaudio 
    alsa-utils
)

CINNAMON_APP_INSTALL=(
    cinnamon
    nemo
    cinnamon-control-center
    cinnamon-screensaver
    gnome-terminal
    xed
    cinnamon-settings-daemon
    cinnamon-session
    networkmanager
    pulseaudio
    gnome-screenshot
    gvfs
    file-roller
)
XFCE_APP_INSTALL=(
    xfce4
    xfce4-goodies
    xfce4-terminal
    thunar
    xfce4-taskmanager
    xfce4-settings
    xfce4-power-manager
    xfce4-screenshooter
    xfce4-pulseaudio-plugin
    xfce4-notifyd
    networkmanager
    gvfs
    evince
    mousepad
)
GNOME_APP_INSTALL=(
    gnome
    gnome-extra
    gnome-shell
    gnome-terminal
    nautilus
    gnome-control-center
    gnome-tweaks
    gnome-calculator
    gnome-system-monitor
    evince
    gedit
    gnome-software
    file-roller
    eog
    gnome-screenshot
    gnome-disk-utility
    gnome-keyring
    gvfs
    networkmanager
    pulseaudio
)

function instalar_pacotes() {
    local lista_pacotes=("$@")
    
    if [ ${#lista_pacotes[@]} -eq 0 ]; then
        echo -e "${VERDE}[ERRO] - Nenhuma lista de pacotes fornecida.${SEM_COR}"
        return 1
    fi

    echo -e "${VERDE}[INFO] - Instalando programas essenciais usando o pacman...${SEM_COR}"

    for pacote in "${lista_pacotes[@]}"; do
        if ! pacman -Q | grep -q "$pacote"; then  
            sudo pacman -S "$pacote" --noconfirm
        else 
            echo -e "${VERDE}[INFO] - O pacote $pacote já está instalado.${SEM_COR}"
        fi
    done
}

# Escolher qual ambiente de desktop instalar usando a instrução case
function escolher_interface() {
    echo -e "${VERDE}[INFO] - Escolha uma interface para instalar:${SEM_COR}"
    echo "1) KDE"
    echo "2) GNOME"
    echo "3) XFCE"
    echo "4) Cinnamon"
    read -p "Digite o número da interface desejada: " opcao

    case $opcao in
        1) instalar_pacotes "${KDE_APP_INSTALL[@]}";;
        2) instalar_pacotes "${GNOME_APP_INSTALL[@]}";;
        3) instalar_pacotes "${XFCE_APP_INSTALL[@]}";;
        4) instalar_pacotes "${CINNAMON_APP_INSTALL[@]}";;
        *) echo -e "${VERDE}[ERRO] - Opção inválida. Nenhuma interface será instalada.${SEM_COR}";;
    esac
}

# Função para instalar pacotes usando o gerenciador de pacotes pacman
function instalar_pacotes() {
    local lista_pacotes=("$@")
    
    if [ ${#lista_pacotes[@]} -eq 0 ]; then
        echo -e "${VERDE}[ERRO] - Nenhuma lista de pacotes fornecida.${SEM_COR}"
        return 1
    fi

    echo -e "${VERDE}[INFO] - Instalando programas essenciais usando o pacman...${SEM_COR}"

    for pacote in "${lista_pacotes[@]}"; do
        if ! pacman -Q | grep -q "$pacote"; then  
            sudo pacman -S "$pacote" --noconfirm
        else 
            echo -e "${VERDE}[INFO] - O pacote $pacote já está instalado.${SEM_COR}"
        fi
    done
}

# Escolher qual ambiente de desktop instalar usando a instrução case
function escolher_interface() {
    echo -e "${VERDE}[INFO] - Escolha uma interface para instalar:${SEM_COR}"
    echo "1) KDE"
    echo "2) GNOME"
    echo "3) XFCE"
    echo "4) Cinnamon"
    read -p "Digite o número da interface desejada: " opcao

    case $opcao in
        1) instalar_pacotes "${KDE_APP_INSTALL[@]}";;
        2) instalar_pacotes "${GNOME_APP_INSTALL[@]}";;
        3) instalar_pacotes "${XFCE_APP_INSTALL[@]}";;
        4) instalar_pacotes "${CINNAMON_APP_INSTALL[@]}";;
        *) echo -e "${VERDE}[ERRO] - Opção inválida. Nenhuma interface será instalada.${SEM_COR}";;
    esac
}

