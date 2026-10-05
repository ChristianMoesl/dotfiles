# Dotfiles

This repository contains my [configuration files](http://dotfiles.github.io). They are

## Install

Manual steps to install dotfiles on a new system

1. Run `install-setup.sh`
2. Download and install nerd font patched Fira Code font from [https://github.com/ryanoasis/nerd-fonts/releases](https://github.com/ryanoasis/nerd-fonts/releases)

### Homebrew installation

```bash
# Leaving a machine
brew bundle dump

# Fresh installation
brew bundle
```

### Configure with Stow

```bash
# Create the symbolic links using GNU stow.
$ git clone https://github.com/ChristianMoesl/dotfiles
$ cd dotfiles
$ stow -t ~ .
```

### Git identity and signing

`.gitconfig` defaults to `christian.git@moesl.net` and signs commits with the
personal Ed25519 key in 1Password using its WSL signing program. This is SSH
signing (`gpg.format = ssh`), not OpenPGP signing.

`~/.gitconfig.local` is included last for machine-specific overrides and is not
committed. See `.gitconfig.local.example` for WSL, native Windows, macOS, and
Linux signer paths, plus optional identity and credential-helper overrides.
Copy the example to `~/.gitconfig.local` if that file does not exist; otherwise
merge the settings you need. Uncomment only the relevant overrides. On non-WSL
machines, override the signing program before committing (or explicitly disable
signing if 1Password is not set up). There is no automatic OS detection.

### MacOS Setup Guide

1. Map cap lock key to ESC in system settings
1. Enable CTRL+number shortcuts for Missing Control in system settings (keyboard)
1. Disable CTRL+Space shortcut for "previous input source" in system settings (keyboard)
1. Enable "reduce motion" in accessibility settings
1. Disable "Automatically rearrange Spaces ..." in Desktop & Dock
1. Configure OpenAI key in ~/.config/nvim/.chat-gpt

## License

[MIT](http://opensource.org/licenses/MIT).
