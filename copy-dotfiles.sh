#!/bin/bash

# Colors
red=$'\e[1;31m'
orange=$'\e[1;33m'
blue=$'\e[1;34m'
violet=$'\e[1;35m'
green=$'\e[1;32m'
white=$'\e[0m'

# Copy files from .config directory
rm -r ./config
mkdir config
echo "${red}> Copy configs..${white}"
cp -r $HOME/.config/awesome ./config
cp -r $HOME/.config/fontconfig ./config
cp -r $HOME/.config/redshift ./config
cp -r $HOME/.config/compton.conf ./config

# Copy binaries
rm -r ./bin
echo "${orange}> Copy binaries..${white}"
cp -r $HOME/bin ./

# Xresources
rm ./Xresources
echo "${blue}> Copy Xresources..${white}"
cp $HOME/.Xresources ./Xresources

# Fonts
rm -r ./fonts
echo "${violet}> Copy fonts..${white}"
cp -r $HOME/.local/share/fonts ./
rm ./fonts/.uuid

echo "${green}Dotfiles copied.${white}"
