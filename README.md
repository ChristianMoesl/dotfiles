# Dotfiles
This repository contains my [configuration files](http://dotfiles.github.io). They are 

## Install
Manual steps to install dotfiles on a new system

1. Run `install-setup.sh`
2. Download and install nerd font patched Fira Code font from [https://github.com/ryanoasis/nerd-fonts/releases](https://github.com/ryanoasis/nerd-fonts/releases)


Usage
-----

Pull the repository, and then create the symbolic links using GNU
stow.

```zsh
$ git clone https://github.com/ChristianMoesl/dotfiles
$ cd dotfiles
$ stow -v -R -t ~ $(ls -d */)
```

License
-------

[MIT](http://opensource.org/licenses/MIT).
