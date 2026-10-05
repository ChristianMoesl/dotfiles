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

The shared `.gitconfig` defaults to `Christian Mösl`, `christian.git@moesl.net`,
and the personal Ed25519 signing key, using 1Password's WSL signing program.
Commit signing is enabled. This is SSH signing (`gpg.format = ssh`), not OpenPGP
signing.

`~/.gitconfig.local` is included last for machine-specific overrides and is not
committed. See `.gitconfig.local.example` for platform-specific 1Password signer
paths, plus optional identity and credential-helper overrides. Copy the example
only if the local file does not exist; otherwise merge the settings you need.
On non-WSL machines, override the signing program before committing (or
explicitly disable signing if no signing agent is configured). There is no
automatic OS detection.

#### macOS: Bitwarden and the work identity

Enable the SSH agent in the Bitwarden desktop app and make both the personal
and Gofore SSH keys available to it. Private keys stay in Bitwarden; Git stores
only their public keys and asks the agent to sign through OpenSSH.

On this Mac, merge the following into `~/.gitconfig.local`:

```gitconfig
[user]
    email = christian.moesl@gofore.com
    signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPklDU6sPmpBLqArC9GWeYktYfmGNGW6+9swIyRu1YBG
[gpg "ssh"]
    program = /usr/bin/ssh-keygen
```

The name, `gpg.format = ssh`, and `commit.gpgsign = true` remain inherited from
the shared config.

Add the socket setting to the machine-local `~/.zshrc.local`, not to shared
shell configuration. The shared `.zshrc` already loads this file:

```bash
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
```

This is the socket for the Bitwarden desktop app installed from the `.dmg`.
For the App Store version, use
`$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock`
instead.

Open a new terminal or run `source ~/.zshrc.local` in the existing one, then
verify agent access:

```bash
ssh-add -l
```

Restart Pi after updating the current terminal so it inherits the new socket.
An already-running Pi process does not pick up changes to its parent shell's
environment.

#### Personal repository overrides

`pi-sbx`, `radar`, and `dotfiles` use `christian.git@moesl.net` and the personal
signing key. Set these in each repository's local Git config, which takes
precedence over `~/.gitconfig.local`:

```bash
personal_key=$(git config --file "$HOME/.gitconfig" --get user.signingkey)
for repo in pi-sbx radar dotfiles; do
  git -C "$HOME/Workspace/$repo" config --local user.email christian.git@moesl.net
  git -C "$HOME/Workspace/$repo" config --local user.signingkey "$personal_key"
done
```

The signing program is still inherited from the machine-local config. Other
repositories should have no local identity/signing overrides, so they inherit
the Gofore identity and key on this Mac. Linked worktrees also read the shared
repository-local config, including its identity/signing overrides. A worktree
can override those values in its own `config.worktree` when
`extensions.worktreeConfig` is enabled.

Inspect configuration sources from inside a repository:

```bash
git config --show-origin --show-scope --get-regexp \
  '^(user\.(name|email|signingkey)|gpg\.format|gpg\.ssh\.program|commit\.gpgsign)$'
```

The output includes inherited and overridden entries, not just final values.
Use `git config --get user.email` and `git config --get user.signingkey` to
check the effective identity. Remove unwanted local overrides individually
with `git config --local --unset-all <key>`; worktree-specific overrides need
`--worktree` instead.

For GitHub's **Verified** badge, register each public key as an **SSH signing
key** and verify the email used by its commits. An `allowedSignersFile` is
needed for local SSH-signature verification, not for creating signatures.

#### Docker SBX forwarding (optional)

SBX configuration is separate from the host Git and shell setup; these dotfiles
are not loaded inside SBX. To forward Bitwarden explicitly from the Mac:

```bash
sbx settings set ssh.agentForwardingEnabled true
sbx settings set ssh.agentSocketPath "$HOME/.bitwarden-ssh-agent.sock"
sbx daemon restart
```

These are global SBX settings, affecting existing sandboxes too. Restarting the
daemon reconnects existing agent forwarders, so choose a suitable time for
active sandbox sessions. No private-key export or host socket bind-mount is
needed. Forwarding allows sandbox processes to request signing/authentication
from the agent; retain Bitwarden's approval protections.

The sandbox image needs OpenSSH client tools and `socat`. Inside the sandbox,
check the forwarded agent and configure Git separately:

```bash
command -v ssh-keygen ssh-add socat
ssh-add -l

git config --global user.name "Christian Mösl"
git config --global user.email christian.moesl@gofore.com
git config --global user.signingkey 'ssh-ed25519 REPLACE_WITH_YOUR_PUBLIC_KEY'
git config --global gpg.format ssh
git config --global gpg.ssh.program ssh-keygen
git config --global commit.gpgsign true
```

Replace the placeholder with the intended public key: the Gofore key above for
work repositories, or the personal key for personal repositories. Apply the
personal repository overrides inside the relevant sandbox repositories too,
using their sandbox paths. Do **not** set the Mac's socket path inside Linux;
SBX supplies the sandbox-local `SSH_AUTH_SOCK`.

### MacOS Setup Guide

1. Map cap lock key to ESC in system settings
1. Enable CTRL+number shortcuts for Missing Control in system settings (keyboard)
1. Disable CTRL+Space shortcut for "previous input source" in system settings (keyboard)
1. Enable "reduce motion" in accessibility settings
1. Disable "Automatically rearrange Spaces ..." in Desktop & Dock
1. Configure OpenAI key in ~/.config/nvim/.chat-gpt

## License

[MIT](http://opensource.org/licenses/MIT).
