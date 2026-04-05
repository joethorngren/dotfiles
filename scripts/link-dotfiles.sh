#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="$HOME"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME_DIR/.dotfiles-backups/$STAMP"

mkdir -p "$BACKUP_DIR"

link_one() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ]; then
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
  fi

  ln -s "$src" "$dst"
  printf 'linked %s -> %s\n' "$dst" "$src"
}

# Top-level dotfiles
for file in .zshrc .zprofile .zshenv .gitconfig .tmux.conf .p10k.zsh; do
  link_one "$DOTFILES_DIR/home/$file" "$HOME_DIR/$file"
done

# Nested config dirs/files
mkdir -p "$HOME_DIR/.config/git"
link_one "$DOTFILES_DIR/home/.config/git/ignore" "$HOME_DIR/.config/git/ignore"

echo "Backups stored in: $BACKUP_DIR"
