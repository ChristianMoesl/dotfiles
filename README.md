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

License
-------

[MIT](http://opensource.org/licenses/MIT).
