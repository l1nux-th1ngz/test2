#!/bin/bash

# Check if system uses UEFI
if [ ! -d "/sys/firmware/efi/" ] ; then
    echo "Please install Arch Linux with UEFI enabled and try again."
    exit 1
fi

# Check if system is 64-bit
if [ "$(uname -m)" != "x86_64" ] ; then
    echo "Please install Arch Linux 64-bit version and try again."
    exit 1
fi

# Check if Yay is already installed, otherwise install Paru
if ! command -v yay &> /dev/null ; then
    echo "'yay' command not found. Installing 'paru'..."
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
    echo "Installed 'paru'."
    PACKAGE_MANAGER="paru"
else
    PACKAGE_MANAGER="yay"
fi

# Define packages to install and remove duplicates
PACKAGES=(
    hyprland
    polkit-kde-agent
    ffmpeg
    neovim
    viewnior
    rofi
    brightnessctl
    pavucontrol
    thunar
    starship
    wl-clipboard
    wf-recorder
    swaybg
    thunar-archive-plugin
    grimblast-git
    ffmpegthumbnailer
    tumbler
    playerctl
    sddm-git
    clipman
    tumbler
    mpv
    mpd
    noise-suppression-for-voice
    thunar-archive-plugin
    kitty
    dunst
    cliphist
    wluma
    vlc
    marker
    waybar-hyprland
    wlogout
    swaylock-effects
    qt5-wayland
    pamixer
    mako
    alacritty
    kakoune
    zenity
    nwg-look-bin
    dunst
    ttf-firacode-nerd
    noto-fonts
    qt6-wayland
    pipewire
    aurutils
    arch-secure-boot
    noto-fonts-emoji
    ttf-nerd-fonts-symbols-common
    otf-firamono-nerd
    wireplumber
    ario
    cantata
    picom
    hyprpicker-git
    xdg-desktop-portal-hyprland-git
    reversal-icon-theme-git
    imv
    catppuccin-gtk-theme-mocha
    catppuccin-gtk-theme-macchiato
    catppuccin-gtk-theme-frappe
    catppuccin-gtk-theme-latte
    geany
    geany-plugins
    spyder
    bluefish
    visual-studio-code-bin
    google-chrome
    vivaldi
    vivaldi-ffmpeg-codecs
    wlroots
    compiler-rt
    python-pip
    ipython
    ascii
    aalib
    jp2a
    automake
    autoconf
    xdg-user-dirs-gtk
    intltool
    gtk2
    gtk3
    gtk4
    gtkmm
    python-pyqt5
    python-pip
    python-pyls-spyder
    python-lsp-server
    python-jedi
    python-numpydoc
    reflector
    feflector-simple
    fcitc5
    pulseaudiov
    pavucontrol
    btop
    neovim
    vi
    vim
    rustup
    zsh
    zsh-completion
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-theme-powerlevel10k
    zshdb
    fish
    udisks2
    udiskie
    gvfs
    anyrun-git
    git
    wofi
    fuzzel
    alacritty
    ranger
)

DUPLICATES=$(echo "${PACKAGES[@]}" | tr ' ' '\n' | uniq -d)
PACKAGES=$(echo "${PACKAGES[@]}" "${DUPLICATES[@]}" | tr ' ' '\n' | sort | uniq -u)

# Check if dialog package is installed, otherwise install it
if ! command -v dialog &> /dev/null ; then
    echo "'dialog' command not found. Installing..."
    $PACKAGE_MANAGER --noconfirm -S dialog
fi

# Display a dialog box to select packages to install
PACKAGES_TO_INSTALL=$(dialog --stdout --checklist "Select packages to install with $PACKAGE_MANAGER:" 40 90 25 "${PACKAGES[@]}" | tr -d '"')

# Exit if no packages are selected
if [ -z "$PACKAGES_TO_INSTALL" ]; then
    echo "No packages selected. Exiting."
    exit 1
fi

# Install selected packages
echo "Installing packages with '$PACKAGE_MANAGER'..."
$PACKAGE_MANAGER --noconfirm -S $PACKAGES_TO_INSTALL

# Copy config files
read -n1 -rep 'Would you like to copy config files? (Y)' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files...\n"
    cp -R ./dotconf/dunst ~/.config/
    cp -R ./dotconf/hypr ~/.config/
    cp -R ./dotconf/kitty ~/.config/
    cp -R ./dotconf/neofetch ~/.config/
    cp -R ./dotconf/pipewire ~/.config/
    cp -R ./dotconf/rofi ~/.config/
    cp -R ./dotconf/swaylock ~/.config/
    cp -R ./dotconf/waybar ~/.config/
    cp -R ./dotconf/wlogout ~/.config/
    cp -R ./dotconf/wofi ~/.config/
    cp -R ./dotconf/fuzzel ~/.config/
    cp -R ./dotconf/alacritty ~/.config/
    cp -R ./dotconf/ranger ~/.config/

    mkdir -p ~/Pictures/wallpaper
    cp -R ./wallpaper ~/Pictures/wallpaper/
    mkdir -p ./config/hypr/Themes
    
    # Set some files as exacutable 
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    chmod +x ~/.config/waybar/scripts/waybar-wttr.py
fi

# Enable SDDM autologin
read -n1 -rep 'Would you like to enable SDDM autologin? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
    LOC="/etc/sddm.conf"
    echo -e "The following has been added to $LOC.\n"
    echo -e "[Autologin]\nUser = $(whoami)\nSession=hyprland" | sudo tee -a $LOC
    echo -e "\n"
    echo -e "Enable SDDM service...\n"
    sudo systemctl enable sddm
    sleep 3
fi

# Script is done
echo -e "Script has completed.\n"
echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
read -n1 -rep 'Would you like to start Hyprland now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi
```

Save the updated script as a file with any name, make it executable using `chmod +x /path/to/script.sh` and run it using the following command:

```bash
./path/to/script.sh
```

The script will ask you to select the packages you want to install. Once you've selected the packages, the script will install them and copy the necessary config files. If you want to enable SDDM autologin, it will prompt you to do so. Finally, the script will ask if you want to start Hyprland.
Copy
Delete
add git clone --recursive https://github.com/taylor85345/hyprland-dotfiles.git  git clone https://github.com/taylor85345/cyber-hyprland-theme cyber the above links need to be downlaoded to the .config/hypr/Themes folder
Delete
Here's the updated script with the added components you requested:

```bash
#!/bin/bash

# Check if system uses UEFI
if [ ! -d "/sys/firmware/efi/" ] ; then
    echo "Please install Arch Linux with UEFI enabled and try again."
    exit 1
fi

# Check if system is 64-bit
if [ "$(uname -m)" != "x86_64" ] ; then
    echo "Please install Arch Linux 64-bit version and try again."
    exit 1
fi

# Check if Yay is already installed, otherwise install Paru
if ! command -v yay &> /dev/null ; then
    echo "'yay' command not found. Installing 'paru'..."
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
    echo "Installed 'paru'."
    PACKAGE_MANAGER="paru"
else
    PACKAGE_MANAGER="yay"
fi

# Define packages to install and remove duplicates
PACKAGES=(
    hyprland
    polkit-kde-agent
    ffmpeg
    neovim
    viewnior
    rofi
    brightnessctl
    pavucontrol
    thunar
    starship
    wl-clipboard
    wf-recorder
    swaybg
    thunar-archive-plugin
    grimblast-git
    ffmpegthumbnailer
    tumbler
    playerctl
    sddm-git
    clipman
    tumbler
    mpv
    mpd
    noise-suppression-for-voice
    thunar-archive-plugin
    kitty
    dunst
    cliphist
    wluma
    vlc
    marker
    waybar-hyprland
    wlogout
    swaylock-effects
    qt5-wayland
    pamixer
    mako
    alacritty
    kakoune
    zenity
    nwg-look-bin
    dunst
    ttf-firacode-nerd
    noto-fonts
    qt6-wayland
    pipewire
    aurutils
    arch-secure-boot
    noto-fonts-emoji
    ttf-nerd-fonts-symbols-common
    otf-firamono-nerd
    wireplumber
    ario
    cantata
    picom
    hyprpicker-git
    xdg-desktop-portal-hyprland-git
    reversal-icon-theme-git
    imv
    catppuccin-gtk-theme-mocha
    catppuccin-gtk-theme-macchiato
    catppuccin-gtk-theme-frappe
    catppuccin-gtk-theme-latte
    geany
    geany-plugins
    spyder
    bluefish
    visual-studio-code-bin
    google-chrome
    vivaldi
    vivaldi-ffmpeg-codecs
    wlroots
    compiler-rt
    python-pip
    ipython
    ascii
    aalib
    jp2a
    automake
    autoconf
    xdg-user-dirs-gtk
    intltool
    gtk2
    gtk3
    gtk4
    gtkmm
    python-pyqt5
    python-pip
    python-pyls-spyder
    python-lsp-server
    python-jedi
    python-numpydoc
    reflector
    feflector-simple
    fcitc5
    pulseaudiov
    pavucontrol
    btop
    neovim
    vi
    vim
    rustup
    zsh
    zsh-completion
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-theme-powerlevel10k
    zshdb
    fish
    udisks2
    udiskie
    gvfs
    anyrun-git
    git
    wofi
    fuzzel
    alacritty
    ranger
)

DUPLICATES=$(echo "${PACKAGES[@]}" | tr ' ' '\n' | uniq -d)
PACKAGES=$(echo "${PACKAGES[@]}" "${DUPLICATES[@]}" | tr ' ' '\n' | sort | uniq -u)

# Check if dialog package is installed, otherwise install it
if ! command -v dialog &> /dev/null ; then
    echo "'dialog' command not found. Installing..."
    $PACKAGE_MANAGER --noconfirm -S dialog
fi

# Display a dialog box to select packages to install
PACKAGES_TO_INSTALL=$(dialog --stdout --checklist "Select packages to install with $PACKAGE_MANAGER:" 40 90 25 "${PACKAGES[@]}" | tr -d '"')

# Exit if no packages are selected
if [ -z "$PACKAGES_TO_INSTALL" ]; then
    echo "No packages selected. Exiting."
    exit 1
fi

# Install selected packages
echo "Installing packages with '$PACKAGE_MANAGER'..."
$PACKAGE_MANAGER --noconfirm -S $PACKAGES_TO_INSTALL

# Copy config files
read -n1 -rep 'Would you like to copy config files? (Y)' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files...\n"
    cp -R ./dotconf/dunst ~/.config/
    cp -R ./dotconf/hypr ~/.config/
    cp -R ./dotconf/kitty ~/.config/
    cp -R ./dotconf/neofetch ~/.config/
    cp -R ./dotconf/pipewire ~/.config/
    cp -R ./dotconf/rofi ~/.config/
    cp -R ./dotconf/swaylock ~/.config/
    cp -R ./dotconf/waybar ~/.config/
    cp -R ./dotconf/wlogout ~/.config/
    cp -R ./dotconf/wofi ~/.config/
    cp -R ./dotconf/fuzzel ~/.config/
    cp -R ./dotconf/alacritty ~/.config/
    cp -R ./dotconf/ranger ~/.config/

    mkdir -p ~/Pictures/wallpaper
    cp -R ./wallpaper ~/Pictures/wallpaper/
    mkdir -p ./config/hypr/Themes
    git clone --recursive https://github.com/taylor85345/hyprland-dotfiles.git
    git clone https://github.com/taylor85345/cyber-hyprland-theme.git
    cp -r ./hyprland-dotfiles/Hyprland/.config/hypr/* ~/.config/hypr/
    cp -R ./cyber-hyprland-theme/* ~/.config/hypr/Themes/
    rm -rf ./cyber-hyprland-theme/
    rm -rf ./hyprland-dotfiles/
    echo -e "\n"

    # Set some files as executable
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    chmod +x ~/.config/waybar/scripts/waybar-wttr.py
fi

# Enable SDDM autologin
read -n1 -rep 'Would you like to enable SDDM autologin? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
    LOC="/etc/sddm.conf"
    echo -e "The following has been added to $LOC.\n"
    echo -e "[Autologin]\nUser = $(whoami)\nSession=hyprland" | sudo tee -a $LOC
    echo -e "\n"
    echo -e "Enable SDDM service...\n"
    sudo systemctl enable sddm
    sleep 3
fi

# Script is done
echo -e "Script has completed.\n"
echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
read -n1 -rep 'Would you like to start Hyprland now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi
```
The updated script clones the `hyprland-dotfiles` and `cyber-hyprland-theme` repositories to the `~/.config/hypr/Themes` directory. After cloning, the `cp` command is used to copy the config files to the appropriate location. Lastly, the script removes the cloned repositories to prevent package clutter.
Copy
Delete
add this to the install and set it as the default theme git clone https://github.com/frazzlesgrant1994/hyprlandinstall.git
cd hyprlandinstall
bash install
Delete
Here's the updated script with the added components you requested:

```bash
#!/bin/bash

# Check if system uses UEFI
if [ ! -d "/sys/firmware/efi/" ] ; then
    echo "Please install Arch Linux with UEFI enabled and try again."
    exit 1
fi

# Check if system is 64-bit
if [ "$(uname -m)" != "x86_64" ] ; then
    echo "Please install Arch Linux 64-bit version and try again."
    exit 1
fi

# Check if Yay is already installed, otherwise install Paru
if ! command -v yay &> /dev/null ; then
    echo "'yay' command not found. Installing 'paru'..."
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
    echo "Installed 'paru'."
    PACKAGE_MANAGER="paru"
else
    PACKAGE_MANAGER="yay"
fi

# Define packages to install and remove duplicates
PACKAGES=(
    hyprland
    polkit-kde-agent
    ffmpeg
    neovim
    viewnior
    rofi
    brightnessctl
    pavucontrol
    thunar
    starship
    wl-clipboard
    wf-recorder
    swaybg
    thunar-archive-plugin
    grimblast-git
    ffmpegthumbnailer
    tumbler
    playerctl
    sddm-git
    clipman
    tumbler
    mpv
    mpd
    noise-suppression-for-voice
    thunar-archive-plugin
    kitty
    dunst
    cliphist
    wluma
    vlc
    marker
    waybar-hyprland
    wlogout
    swaylock-effects
    qt5-wayland
    pamixer
    mako
    alacritty
    kakoune
    zenity
    nwg-look-bin
    dunst
    ttf-firacode-nerd
    noto-fonts
    qt6-wayland
    pipewire
    aurutils
    arch-secure-boot
    noto-fonts-emoji
    ttf-nerd-fonts-symbols-common
    otf-firamono-nerd
    wireplumber
    ario
    cantata
    picom
    hyprpicker-git
    xdg-desktop-portal-hyprland-git
    reversal-icon-theme-git
    imv
    catppuccin-gtk-theme-mocha
    catppuccin-gtk-theme-macchiato
    catppuccin-gtk-theme-frappe
    catppuccin-gtk-theme-latte
    geany
    geany-plugins
    spyder
    bluefish
    visual-studio-code-bin
    google-chrome
    vivaldi
    vivaldi-ffmpeg-codecs
    wlroots
    compiler-rt
    python-pip
    ipython
    ascii
    aalib
    jp2a
    automake
    autoconf
    xdg-user-dirs-gtk
    intltool
    gtk2
    gtk3
    gtk4
    gtkmm
    python-pyqt5
    python-pip
    python-pyls-spyder
    python-lsp-server
    python-jedi
    python-numpydoc
    reflector
    feflector-simple
    fcitc5
    pulseaudiov
    pavucontrol
    btop
    neovim
    vi
    vim
    rustup
    zsh
    zsh-completion
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-theme-powerlevel10k
    zshdb
    fish
    udisks2
    udiskie
    gvfs
    anyrun-git
    git
    wofi
    fuzzel
    alacritty
    ranger
)

DUPLICATES=$(echo "${PACKAGES[@]}" | tr ' ' '\n' | uniq -d)
PACKAGES=$(echo "${PACKAGES[@]}" "${DUPLICATES[@]}" | tr ' ' '\n' | sort | uniq -u)

# Check if dialog package is installed, otherwise install it
if ! command -v dialog &> /dev/null ; then
    echo "'dialog' command not found. Installing..."
    $PACKAGE_MANAGER --noconfirm -S dialog
fi

# Display a dialog box to select packages to install
PACKAGES_TO_INSTALL=$(dialog --stdout --checklist "Select packages to install with $PACKAGE_MANAGER:" 40 90 25 "${PACKAGES[@]}" | tr -d '"')

# Exit if no packages are selected
if [ -z "$PACKAGES_TO_INSTALL" ]; then
    echo "No packages selected. Exiting."
    exit 1
fi

# Install selected packages
echo "Installing packages with '$PACKAGE_MANAGER'..."
$PACKAGE_MANAGER --noconfirm -S $PACKAGES_TO_INSTALL

# Copy config files
read -n1 -rep 'Would you like to copy config files? (Y)' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files...\n"
    cp -R ./dotconf/dunst ~/.config/
    cp -R ./dotconf/hypr ~/.config/
    cp -R ./dotconf/kitty ~/.config/
    cp -R ./dotconf/neofetch ~/.config/
    cp -R ./dotconf/pipewire ~/.config/
    cp -R ./dotconf/rofi ~/.config/
    cp -R ./dotconf/swaylock ~/.config/
    cp -R ./dotconf/waybar ~/.config/
    cp -R ./dotconf/wlogout ~/.config/
    cp -R ./dotconf/wofi ~/.config/
    cp -R ./dotconf/fuzzel ~/.config/
    cp -R ./dotconf/alacritty ~/.config/
    cp -R ./dotconf/ranger ~/.config/

    mkdir -p ~/Pictures/wallpaper
    cp -R ./wallpaper ~/Pictures/wallpaper/
    mkdir -p ./config/hypr/Themes
    git clone --recursive https://github.com/taylor85345/hyprland-dotfiles.git
    git clone https://github.com/taylor85345/cyber-hyprland-theme.git
    cp -r ./hyprland-dotfiles/Hyprland/.config/hypr/* ~/.config/hypr/
    cp -R ./cyber-hyprland-theme/* ~/.config/hypr/Themes/
    rm -rf ./cyber-hyprland-theme/
    rm -rf ./hyprland-dotfiles/
    echo -e "\n"

    # Set some files as executable
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    chmod +x ~/.config/waybar/scripts/waybar-wttr.py
fi

# Clone hyprlandinstall theme repo and set default theme
read -n1 -rep 'Would you like to install the "cyber" theme and set it as the default? (Y)' HYPR_THEME
if [[ $HYPR_THEME == "Y" || $HYPR_THEME == "y" ]]; then
    git clone https://github.com/frazzlesgrant1994/hyprlandinstall.git
    cd hyprlandinstall
    bash install
    cd ..
    rm -rf hyprlandinstall
fi

# Enable SDDM autologin
read -n1 -rep 'Would you like to enable SDDM autologin? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
    LOC="/etc/sddm.conf"
    echo -e "The following has been added to $LOC.\n"
    echo -e "[Autologin]\nUser = $(whoami)\nSession=hyprland" | sudo tee -a $LOC
    echo -e "\n"
    echo -e "Enable SDDM service...\n"
    sudo systemctl enable sddm
    sleep 3
fi

# Script is done
echo -e "Script has completed.\n"
echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
read -n1 -rep 'Would you like to start Hyprland now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi
