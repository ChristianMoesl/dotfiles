# Dotfiles
This repository contains my [configuration files](http://dotfiles.github.io). They are 

Usage
-----

Pull the repository, and then create the symbolic links using GNU
stow.

```zsh
$ git clone https://github.com/ChristianMoesl/dotfiles
$ cd dotfiles
$ stow -v -R -t ~ brew git gnupg nvim rbenv ssh zsh  # folder of configuration files to be used
```

License
-------

[MIT](http://opensource.org/licenses/MIT).
