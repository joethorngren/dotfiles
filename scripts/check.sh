#!/usr/bin/env bash
# check.sh — Verify all expected tools are installed
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
DIM='\033[2m'
RESET='\033[0m'

echo ""
echo "  Dotfiles Health Check"
echo "  ─────────────────────"

TOOLS=(
  zsh git tmux fzf rg fd bat eza zoxide delta jq direnv gh yq
  neovim starship atuin htop wget curl node python3 fnm pipx
)

PASS=0
MISS=0

for t in "${TOOLS[@]}"; do
  if command -v "$t" >/dev/null 2>&1; then
    VER="$($t --version 2>/dev/null | head -1 || echo '')"
    printf "  ${GREEN}✓${RESET} %-12s ${DIM}%s${RESET}\n" "$t" "$VER"
    PASS=$((PASS + 1))
  else
    printf "  ${RED}✗${RESET} %-12s ${DIM}(not found)${RESET}\n" "$t"
    MISS=$((MISS + 1))
  fi
done

# Optional tools (don't count as failures)
echo ""
echo "  Optional:"
for t in rustc claude docker; do
  if command -v "$t" >/dev/null 2>&1; then
    VER="$($t --version 2>/dev/null | head -1 || echo '')"
    printf "  ${GREEN}✓${RESET} %-12s ${DIM}%s${RESET}\n" "$t" "$VER"
  else
    printf "  ${DIM}○${RESET} %-12s ${DIM}(not installed)${RESET}\n" "$t"
  fi
done

echo ""
echo "  ─────────────────────"
echo -e "  ${GREEN}$PASS passed${RESET}, ${RED}$MISS missing${RESET}"
echo ""
