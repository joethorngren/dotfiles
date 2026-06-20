# dotfiles (macOS + iTerm2 + WSL)

Portable shell setup that keeps one source of truth for your terminal UX across:
- macOS with iTerm2
- Windows with WSL (via Windows Terminal)

## What this repo manages
- `home/.zshrc`, `home/.zprofile`, `home/.zshenv`
- `home/.gitconfig`, `home/.tmux.conf`, `home/.config/git/ignore`
- `iterm2/DynamicProfiles/dotfiles-profile.json`
- `Brewfile` for currently installed top-level Homebrew formulae/casks
- WSL-friendly bootstrap and Windows Terminal settings snippet

## Install on macOS
```bash
cd ~/dotfiles
bash scripts/bootstrap-macos.sh
```

## Restore Homebrew state only
This mirrors the top-level formulae/casks currently installed on the Mac.
```bash
brew bundle --file Brewfile
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

## Windows Terminal setup for WSL
Open Windows Terminal settings and merge the snippet in:
- `windows/windows-terminal.settings.jsonc`

Most important part: set font to a Nerd Font (`JetBrainsMono Nerd Font`) so powerlevel10k symbols render correctly.

## Local, non-committed overrides
Use these for machine-specific values:
- `~/.zshrc.local`
- `~/.zprofile.local`
- `~/.gitconfig-work`
- `~/.secrets.env`

The committed Git config uses GitHub CLI as the credential helper for GitHub and
Gist. Run `gh auth login` after linking dotfiles on a fresh machine.

## Tooling research
See:
- `docs/tooling-2026-02.md`
