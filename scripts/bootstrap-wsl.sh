#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! grep -qi microsoft /proc/version 2>/dev/null; then
  echo "This script is intended for WSL."
  exit 1
fi

sudo apt-get update
sudo apt-get install -y \
  zsh git tmux curl unzip build-essential fzf ripgrep fd-find bat jq

# Normalize binary names on Debian/Ubuntu
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

# Install eza (modern ls)
if ! command -v eza >/dev/null 2>&1; then
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update
  sudo apt-get install -y eza
fi

# Install zoxide
if ! command -v zoxide >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# oh-my-zsh + powerlevel10k
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# Link dotfiles
bash "$DOTFILES_DIR/scripts/link-dotfiles.sh"

# Set zsh as default shell
if command -v zsh >/dev/null 2>&1; then
  chsh -s "$(command -v zsh)" "$USER" || true
fi

echo "WSL bootstrap complete."
echo "Next: apply windows/windows-terminal.settings.jsonc snippets in Windows Terminal settings."
