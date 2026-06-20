# dotfiles (macOS + iTerm2 + WSL)

Portable shell setup that keeps one source of truth for your terminal UX across:
- macOS with iTerm2
- Windows with WSL (via Windows Terminal)

## What this repo manages
- `home/.zshrc`, `home/.zprofile`, `home/.zshenv`
- `home/.gitconfig`, `home/.tmux.conf`, `home/.p10k.zsh`,
  `home/.config/git/ignore`
- `iterm2/DynamicProfiles/dotfiles-profile.json`
- `macos/Brewfile` for Mac-only Homebrew formulae/casks plus npm, cargo,
  uv, and VS Code extension entries
- WSL-friendly bootstrap and Windows Terminal settings snippet

## Install on macOS
```bash
cd ~/dotfiles
bash scripts/bootstrap-macos.sh
```

## Restore macOS package/app state only
This mirrors every Homebrew-installable formula/cask we care about, plus npm,
cargo, uv, and VS Code entries. Use `scripts/bootstrap-macos.sh` for the full
fresh-Mac pass; it also tries to adopt existing apps into Homebrew ownership.
```bash
brew bundle --file macos/Brewfile
```

## Install on Lighthouse/Linux
Use this repo for shared shell/git/tmux config. Keep machine-specific GPU,
CUDA, and distro package setup in the Lighthouse setup repo/script, then run the
dotfile linker here:
```bash
bash scripts/link-dotfiles.sh
```

## Install on WSL
Clone this repo inside your WSL home, then:
```bash
cd ~/dotfiles
bash scripts/bootstrap-wsl.sh
```

## Apply/update dotfiles only
```bash
bash scripts/link-dotfiles.sh
```

This script safely backs up existing files to:
- `~/.dotfiles-backups/<timestamp>/`

## iTerm2 setup
The bootstrap script copies `iterm2/DynamicProfiles/dotfiles-profile.json` to iTerm2's DynamicProfiles folder.
Restart iTerm2 and choose the `Dotfiles` profile.

## Powerlevel10k setup
The committed `home/.p10k.zsh` is linked to `~/.p10k.zsh`, so the prompt does
not need to be reconfigured on each machine.

## Windows Terminal setup for WSL
Open Windows Terminal settings and merge the snippet in:
- `windows/windows-terminal.settings.jsonc`

Most important part: set font to a Nerd Font (`JetBrainsMono Nerd Font`) so powerlevel10k symbols render correctly.

## Local, non-committed overrides
Use these for machine-specific values:
- `~/.zshrc.local`
- `~/.zprofile.local`
- `~/.zsh.d/*.zsh`
- `~/.gitconfig-local`
- `~/.gitconfig-work`
- `~/.secrets.env`

The committed Git config uses GitHub CLI as the credential helper for GitHub and
Gist. Run `gh auth login` after linking dotfiles on a fresh machine.

## Tooling research
See:
- `docs/tooling-2026-02.md`
- `docs/macos-inventory-2026-06-20.md`
