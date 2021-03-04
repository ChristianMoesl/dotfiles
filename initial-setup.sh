#!/usr/bin/env zsh

set -euxo pipefail

# Install brew and  tap additional repositories
export CI=1 # do not ask user for something
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew tap homebrew/cask-fonts
brew tap homebrew/cask-drivers

# Create Workspace and clone dotfiles repository
mkdir ~/Workspace
cd ~/Workspace

git clone https://github.com/ChristianMoesl/dotfiles
cd dotfiles

# company install
#git fetch origin
#git checkout --track origin/emundo

# Map all dotfiles into the home directory
brew install stow
stow -v -R -t ~ $(ls -d */)

# Install all the software
brew cask install $(cat brew/.config/brew/installed-casks)
brew install $(cat brew/.config/brew/installed-packages)
npm install --global yarn

# install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

# install OhMyZsh plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Fix ZSH config after OhMyZsh installation
rm ~/.zshrc
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc

# Install Nvim plugin manager
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install python3 provider for neovim
python3 -m pip install --user --upgrade pynvim

# Enable TouchID for sudo
# !!! this pam module has to be installed fabianishere/personal/pam_reattach !!!
sudo zsh -c "echo \"$(awk 'NR==1{print; print "auth optional pam_reattach.so\nauth sufficient pam_tid.so"} NR!=1' /etc/pam.d/sudo)\" > /etc/pam.d/sudo"

# Fix GNUPG home directory permissions
# Set ownership to your own user and primary group
chown -R "$USER:$(id -gn)" ~/.gnupg
# Set permissions to read, write, execute for only yourself, no others
chmod 700 ~/.gnupg
# Set permissions to read, write for only yourself, no others
chmod 600 ~/.gnupg/*

# Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Everything is installed, but there is something left todo"
echo "- import settings for iterm2 from ~/.config/iterm2"
echo "- please start NVIM and run :PlugInstall to finishe installation"
