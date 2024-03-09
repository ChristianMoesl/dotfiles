#!/usr/bin/env zsh

set -euxo pipefail

# Install brew and tap additional repositories
export CI=1 # do not ask user for something
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install mas

# Create Workspace and clone dotfiles repository
mkdir ~/Workspace
git clone https://github.com/ChristianMoesl/dotfiles ~/Workspace/dotfiles
cd ~/Workspace/dotfiles
stow .

# Install all dependencies
brew bundle

# Install all the software
xargs brew install < ~/.config/homebrew/leaves.txt

# Install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

# Install OhMyZsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Fix ZSH config after OhMyZsh installation
rm ~/.zshrc
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
source ~/.zshrc

# Setup Kitty
/opt/homebrew/bin/kitty +kitten themes --reload-in=all Catppuccin-Mocha

# Install catpuccin-Mocha theme for bat
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build

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

# Install SDK man
curl -s "https://get.sdkman.io" | zsh

echo "Everything is installed"
