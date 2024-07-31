# Dotfiles
This repository contains my [configuration files](http://dotfiles.github.io). They are 

## Install
Manual steps to install dotfiles on a new system

1. Run `install-setup.sh`
2. Download and install nerd font patched Fira Code font from [https://github.com/ryanoasis/nerd-fonts/releases](https://github.com/ryanoasis/nerd-fonts/releases)


#### Homebrew installation:
```bash
# Leaving a machine
brew bundle dump

# Fresh installation
brew bundle
```

#### Configure with Stow
```bash
# Create the symbolic links using GNU stow.
$ git clone https://github.com/ChristianMoesl/dotfiles
$ cd dotfiles
$ stow -t ~ .
```

### MacOS Setup Guide

1. Map cap lock key to ESC in system settings
2. Enable CTRL+number shortcuts for Missing Control in system settings (keyboard)
3. Enable "reduce motion" in accessibility settings
4. Disable "Automatically rearrange Spaces ..." in Desktop & Dock
5. Configure OpenAI key in ~/.config/nvim/.chat-gpt

License
-------

[MIT](http://opensource.org/licenses/MIT).
