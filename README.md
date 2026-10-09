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

### Pi subagents

`.pi/agent/agents/` defines seven global roles for `@gotgenes/pi-subagents`.
Stow links the directory into `~/.pi/agent/agents/`.

The setup is cost-conscious rather than a mandatory multi-agent pipeline:
Sol supervises, Haiku handles routine delegated work, Sol specialists handle
ambiguity or high risk, and Opus handles visual-design deliverables. The parent
startup default is `github-copilot/gpt-6.1-sol` with `high` thinking.

All models below use the `github-copilot/` provider prefix.

| Agent | Model | Thinking | Turns | Use |
| --- | --- | --- | --- | --- |
| `Explore` | `claude-haiku-5.5` | low | 16 | Bounded discovery with file/line evidence; no edits |
| `worker-fast` | `claude-haiku-5.5` | low | 20 | Default routine implementer, including focused tests |
| `Verify` | `claude-haiku-5.5` | low | 16 | Separate checks when useful; no source edits or fixes |
| `Plan` | `gpt-6.1-sol` | high | 24 | Material design decisions; no edits |
| `general-purpose` | `gpt-6.1-sol` | high | 40 | Difficult debugging, high-risk work, or Haiku escalation |
| `Review` | `gpt-6.1-sol` | high | 24 | Independent, evidence-backed review; no edits or submissions |
| `Visual` | `claude-opus-5.5` | high | 32 | HTML presentations, GUI concepts, and visual aids |

Keep the automatic routing policy in the personal `~/.pi/agent/AGENTS.md`
(managed separately from this repository). Handle tiny tasks directly, default
routine delegation to Haiku, and use planning, separate verification, and review
only when they add value. Escalate unresolved technical blockers with the evidence
already collected, not repeated blind retries. Missing user decisions or
permissions require clarification, not a stronger model. Do not assign overlapping
edits or run checks while another worker changes the same files.

All roles default to fresh context and lock only their model. Supply a compact
task brief with scope, constraints, acceptance criteria, and relevant evidence.
Thinking levels, turn ceilings, context inheritance, and foreground/background
mode remain caller-selectable. Turn ceilings are not hard token or cost budgets.
To escalate to another model, dispatch the appropriate role; overriding a locked
model in a tool call is ignored.

All roles allow `codemode` for batching independent tool calls. Workers can edit;
Explore, Plan, and Review retain Bash for Git inspection, so their read-only
behavior is instruction-based, not an enforced shell sandbox. Verify can run
tests/builds that generate artifacts and reports those changes without fixing or
cleaning them. Visual uses the existing `playwright-cli` skill for preview,
reports verification gaps, and follows the personal screenshot-location policy.

After changing definitions or personal instructions, run `/reload` in Pi.
The parent thinking default applies at startup; use `/thinking` to change the
current session (resumed sessions retain their recorded selection). To change a
role's model, edit its `model:` frontmatter. The model must be available to Pi;
the parent's `enabledModels` cycling list does not restrict these subagents.
Project-local `.pi/agents/<name>.md` definitions take precedence over the global
files. Agent files are complete definitions, not partial patches.

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

Add the socket setting to the machine-local `~/.zshenv.local`, not to shared
shell configuration. The shared `.zshenv` loads this file for both interactive
and non-interactive zsh shells. Remove any old `SSH_AUTH_SOCK` export from
`~/.zshrc.local` so it cannot override this guard:

```zsh
# Use Bitwarden locally without overriding SSH-forwarded agents.
if [[ -z "$SSH_CONNECTION" && -S "$HOME/.bitwarden-ssh-agent.sock" ]]; then
  export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
fi
```

The guard preserves the inherited agent in SSH sessions and when the Bitwarden
socket is absent. This is the socket for the Bitwarden desktop app installed
from the `.dmg`. For the App Store version, use
`$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock`
in both places instead.

Open a new terminal or run `source ~/.zshenv.local` in the existing one, then
verify agent access:

```bash
ssh-add -l
```

Restart Pi from that terminal so it inherits the new socket. Bash subprocesses
do not read `.zshenv`; they inherit the environment of the process launching
them. An already-running Pi process does not pick up changes to its parent
shell's environment, and GUI launchers may need separate environment setup.

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
