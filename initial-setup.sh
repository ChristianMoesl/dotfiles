#!/usr/bin/env zsh

set -euxo pipefail

# Install brew and tap additional repositories
export CI=1 # do not ask user for something
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew tap homebrew/cask-fonts

# Create ZSH history file
mkdir -p ~/.cache/zsh
touch ~/.cache/zsh/history

# Create Workspace and clone dotfiles repository
mkdir ~/Workspace
cd ~/Workspace

git clone https://github.com/ChristianMoesl/dotfiles
cd dotfiles

# Map all dotfiles into the home directory
brew install stow
stow -v -R -t ~ $(ls -d */)

# Install all the software
brew install --cask $(cat brew/.config/brew/installed-casks)
brew install $(cat brew/.config/brew/installed-packages)
npm install --global yarn

# install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

# install OhMyZsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Fix ZSH config after OhMyZsh installation
rm ~/.zshrc
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc

# Setup Kitty
kitty +kitten themes --reload-in=all Catppuccin-Mocha

# Install python3 provider for neovim
python3 -m pip install --user --upgrade pynvim

# Fix GNUPG home directory permissions
# Set ownership to your own user and primary group
chown -R "$USER:$(id -gn)" ~/.gnupg
# Set permissions to read, write, execute for only yourself, no others
chmod 700 ~/.gnupg
# Set permissions to read, write for only yourself, no others
chmod 600 ~/.gnupg/*

# Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Allow press and hold in VSCode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# install github cli extension to get default branch
gh extension install daido1976/gh-default-branch

# install catpuccin-Mocha theme for bat
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build

echo "Everything is installed, but there is something left todo"
echo "- import settings for iterm2 from ~/.config/iterm2"
echo "- please start NVIM and run :PlugInstall to finishe installation"
