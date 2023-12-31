#!/bin/bash

read -s -p "Enter Password for sudo: " sudoPW

echo "Setting up SSH"
echo $sudoPW | sudo -S pacman --noconfirm --needed -S openssh
sudo systemctl enable sshd
sudo systemctl start sshd

echo "Installing packages"
sudo pacman --noconfirm --needed -S qemu-guest-agent libxft libxinerama git yajl nano vim xorg-xrandr xorg-xsetroot picom wget unzip less htop neofetch xwallpaper feh qutebrowser firefox ranger ueberzug xdotool tmux mpv sxhkd ttf-jetbrains-mono ttf-joypixels ttf-font-awesome exa bat fd xh sd dog zellij python-pywal lxappearance rofi network-manager-applet zsh zsh-syntax-highlighting sddm cargo go

echo "Installing Oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Creating directories"
mkdir -p ~/.local/src
mkdir -p ~/.local/bin
mkdir ~/.config
mkdir ~/pix

echo "Cloning source files"
git clone https://github.com/macblizzard/dusk ~/.local/src/dusk
git clone https://github.com/macblizzard/dmenu ~/.local/src/dmenu
git clone https://github.com/macblizzard/st ~/.local/src/st

echo "Copying scripts"
cp -r scripts/* ~/.local/bin/

echo "Copying images"
cp -r pix/* ~/pix/

echo "Changing shell"
echo $sudoPW | chsh -s /usr/bin/zsh

echo "Copying dotfiles and setting up symlinks"
cp -r dotfiles/* ~/.config/
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
rm ~/.zshrc
ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/zsh/.zshenv ~/.zshenv
ln -s ~/.config/zsh/.zprofile ~/.zprofile
ln -s ~/.config/x11/.xinitrc ~/.xinitrc
ln -s ~/.config/x11/.Xresources ~/.Xresources
sudo cp ~/.config/x11/Xwrapper.config /etc/X11/Xwrapper.config

source ~/.zshenv
source ~/.zshrc
source ~/.zprofile

echo "Setting up YAY and installing AUR packages"
git clone https://aur.archlinux.org/yay.git
cd yay
echo $sudoPW | makepkg -si --noconfirm
yay -S --noconfirm python-pywalfox themix-gui-git themix-theme-oomox-git xorgxrdp-glamor sddm-theme-tokyo-night sddm-theme-sugar-candy-git ttf-hack-nerd-font

echo "Enabling services"
sudo systemctl enable xrdp

echo "Building sources"
cd ~/.local/src/dusk/ && sudo make clean install
cd ~/.local/src/dmenu/ && sudo make clean install
cd ~/.local/src/st/ && sudo make clean install

echo "Making executables"
sudo chmod +x ~/.local/bin/*

echo "Setup is complete, please reboot the system and type startx"
echo "To get pywal colors for gtk apps…"
echo "Open themix-gui and go to plugins - Xresources - xresources-reverse and click on export theme and export icons"
echo "Open lxappearance and under Widget select oomox-xresources-reverse and apply"
echo "Then go to icon theme tab and select oomox-resources-reverse and apply"
