#!/usr/bin/env bash
# bootstrap-macos.sh — Idempotent macOS dev environment setup
# Safe to run multiple times. Skips what's already installed.
# Usage: bash scripts/bootstrap-macos.sh [--profile personal|rfs|keenan]
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$DOTFILES_DIR/macos/Brewfile"
PROFILE="${1:---profile}"
PROFILE_NAME="${2:-personal}"

# If first arg is --profile, use second arg. Otherwise default to personal.
if [[ "$PROFILE" == "--profile" ]]; then
  PROFILE_NAME="${PROFILE_NAME}"
else
  PROFILE_NAME="personal"
fi

# ─── Colors & Output ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

PASS="${GREEN}✓${RESET}"
SKIP="${DIM}○${RESET}"
INSTALL="${CYAN}↓${RESET}"
FAIL="${RED}✗${RESET}"
STEP=0

step() {
  STEP=$((STEP + 1))
  echo ""
  echo -e "${BOLD}${BLUE}[$STEP]${RESET} ${BOLD}$1${RESET}"
  echo -e "${DIM}$(printf '%.0s─' {1..60})${RESET}"
}

ok()      { echo -e "  ${PASS} $1"; }
skip()    { echo -e "  ${SKIP} $1 ${DIM}(already installed)${RESET}"; }
install() { echo -e "  ${INSTALL} $1"; }
fail()    { echo -e "  ${FAIL} $1"; }
info()    { echo -e "  ${DIM}$1${RESET}"; }

# ─── Banner ───────────────────────────────────────────────────────
clear
echo -e "${BOLD}${CYAN}"
cat << 'BANNER'
    ┌─────────────────────────────────────────┐
    │   macOS Bootstrap — The Honesty Era      │
    │   Safe to run. Skips what's installed.    │
    └─────────────────────────────────────────┘
BANNER
echo -e "${RESET}"
echo -e "  ${DIM}Profile:${RESET}  ${BOLD}${PROFILE_NAME}${RESET}"
echo -e "  ${DIM}Dotfiles:${RESET} ${DOTFILES_DIR}"
echo -e "  ${DIM}Machine:${RESET}  $(scutil --get ComputerName 2>/dev/null || hostname)"
echo -e "  ${DIM}macOS:${RESET}    $(sw_vers -productVersion)"
echo -e "  ${DIM}Chip:${RESET}     $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo 'unknown')"
echo ""

# ─── 1. Homebrew ──────────────────────────────────────────────────
step "Homebrew"

if command -v brew >/dev/null 2>&1; then
  skip "Homebrew $(brew --version | head -1 | awk '{print $2}')"
else
  install "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ok "Homebrew installed"
fi

# Ensure brew in PATH for this session
if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

install "Updating Homebrew..."
brew update --quiet
ok "Homebrew up to date"

# ─── 2. Rust Prerequisite ────────────────────────────────────────
step "Rust"

if command -v rustc >/dev/null 2>&1; then
  skip "Rust $(rustc --version | awk '{print $2}')"
else
  install "Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  ok "Rust installed"
fi

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ─── 3. macOS Bundle ─────────────────────────────────────────────
step "macOS Bundle"

if [ ! -f "$BREWFILE" ]; then
  fail "Missing Brewfile at $BREWFILE"
fi

for tap in hudochenkov/sshpass itchyny/tap nikitabobko/tap steipete/tap stripe/stripe-cli yakitrak/yakitrak; do
  brew tap "$tap" >/dev/null 2>&1 || true
done

brew trust hudochenkov/sshpass itchyny/tap nikitabobko/tap steipete/tap stripe/stripe-cli yakitrak/yakitrak >/dev/null 2>&1 ||
  info "Some third-party Homebrew taps may need manual trust before install/upgrade checks"

ADOPTABLE_CASKS=(
  caldigit-docking-utility
  claude
  discord
  google-chrome
  google-chrome@beta
  ollama-app
  prusaslicer
  shottr
  signal
  slack
  telegram
  vysor
)

app_exists_for_cask() {
  case "$1" in
    caldigit-docking-utility)
      [ -d "/Applications/CalDigit Docking Station Utility" ] ||
        [ -d "/Applications/CalDigit Docking Station Utility/CalDigit_Docking_Station_Utility.app" ]
      ;;
    claude) [ -d "/Applications/Claude.app" ] ;;
    discord) [ -d "/Applications/Discord.app" ] ;;
    google-chrome) [ -d "/Applications/Google Chrome.app" ] ;;
    google-chrome@beta) [ -d "/Applications/Google Chrome Beta.app" ] ;;
    ollama-app) [ -d "/Applications/Ollama.app" ] || command -v ollama >/dev/null 2>&1 ;;
    prusaslicer)
      [ -d "/Applications/PrusaSlicer.app" ] ||
        [ -d "/Applications/Original Prusa Drivers/PrusaSlicer.app" ]
      ;;
    shottr) [ -d "/Applications/Shottr.app" ] ;;
    signal) [ -d "/Applications/Signal.app" ] ;;
    slack) [ -d "/Applications/Slack.app" ] ;;
    telegram) [ -d "/Applications/Telegram.app" ] || [ -d "/Applications/Telegram for macOS.app" ] ;;
    vysor) [ -d "/Applications/Vysor.app" ] ;;
    *) return 1 ;;
  esac
}

for cask in "${ADOPTABLE_CASKS[@]}"; do
  if ! brew list --cask "$cask" >/dev/null 2>&1 && app_exists_for_cask "$cask"; then
    install "Adopting existing $cask app into Homebrew..."
    brew install --cask --adopt "$cask" || info "$cask could not be adopted; brew bundle may require a manual reinstall"
  fi
done

install "Installing Homebrew, cask, npm, cargo, uv, and VS Code entries..."
brew bundle --file "$BREWFILE"
ok "macOS bundle applied"

# ─── 4. fzf Key Bindings ────────────────────────────────────────
step "fzf Integration"

if [ -f "$HOME/.fzf.zsh" ]; then
  skip "fzf key bindings"
else
  install "Configuring fzf..."
  "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish --no-update-rc 2>/dev/null || true
  ok "fzf key bindings installed"
fi

# ─── 5. Oh My Zsh ───────────────────────────────────────────────
step "Oh My Zsh + Powerlevel10k"

if [ -d "$HOME/.oh-my-zsh" ]; then
  skip "Oh My Zsh"
else
  install "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ok "Oh My Zsh installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  skip "Powerlevel10k"
else
  install "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
  ok "Powerlevel10k installed"
fi

# zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  skip "zsh-autosuggestions"
else
  install "Installing zsh-autosuggestions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  ok "zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  skip "zsh-syntax-highlighting"
else
  install "Installing zsh-syntax-highlighting..."
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  ok "zsh-syntax-highlighting"
fi

# ─── 6. Link Dotfiles ───────────────────────────────────────────
step "Dotfiles"

install "Linking dotfiles..."
bash "$DOTFILES_DIR/scripts/link-dotfiles.sh"
ok "Dotfiles linked"

# ─── 7. iTerm2 Profile ──────────────────────────────────────────
step "iTerm2 Profile"

ITERM_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
ITERM_SRC="$DOTFILES_DIR/iterm2/DynamicProfiles/dotfiles-profile.json"

if [ -f "$ITERM_SRC" ]; then
  mkdir -p "$ITERM_PROFILES_DIR"
  cp "$ITERM_SRC" "$ITERM_PROFILES_DIR/dotfiles-profile.json"
  ok "iTerm2 profile synced"
else
  skip "No iTerm2 profile found in dotfiles"
fi

# ─── 8. Runtime Sanity ───────────────────────────────────────────
step "Bun"

if command -v bun >/dev/null 2>&1; then
  skip "Bun $(bun --version)"
else
  install "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
  ok "Bun installed"
fi

# ─── 9. Runtime Sanity ───────────────────────────────────────────
step "Runtime Sanity"

for tool in node npm python3 uv cargo; do
  if command -v "$tool" >/dev/null 2>&1; then
    skip "$tool"
  else
    info "$tool not found after bundle; check Homebrew output above"
  fi
done

info "npm, cargo, uv, and VS Code globals are managed in macos/Brewfile"

# ─── 12. macOS Defaults ─────────────────────────────────────────
step "macOS Preferences"

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true 2>/dev/null && ok "Finder: show hidden files" || skip "Finder hidden files"

# Don't write .DS_Store on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true 2>/dev/null && ok "Disable .DS_Store on network volumes" || skip ".DS_Store setting"

# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2 2>/dev/null && ok "Fast key repeat" || skip "Key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 15 2>/dev/null && ok "Fast initial key repeat" || skip "Initial key repeat"

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true 2>/dev/null && ok "Finder: show path bar" || skip "Path bar"

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false 2>/dev/null && ok "Disable auto-correct" || skip "Auto-correct"

# ─── 13. Git Config ─────────────────────────────────────────────
step "Git Configuration"

if git config --global user.name >/dev/null 2>&1; then
  skip "Git user: $(git config --global user.name)"
else
  info "Git user.name not set — will be set by dotfiles link"
fi

if git config --global user.email >/dev/null 2>&1; then
  skip "Git email: $(git config --global user.email)"
else
  info "Git user.email not set — will be set by dotfiles link"
fi

# ─── 14. Profile-Specific Setup ─────────────────────────────────
step "Profile: ${PROFILE_NAME}"

case "$PROFILE_NAME" in
  personal)
    info "Personal profile: full dev environment + AI tools + Rust"
    info "After restart, also run: gh auth login"
    info "Then clone dotfiles-ai: gh repo clone joethorngren/dotfiles-ai"
    ;;
  rfs)
    info "Rounds for Squares profile: full dev environment + HIPAA tools"
    info "After restart: gh auth login"
    info "Then clone RFS repos from joeRoundsForSquares GitHub org"
    ;;
  keenan)
    info "Keenan profile: dev environment basics + onboarding"
    info "After restart: gh auth login"
    info "Keenan will need: VS Code extensions, Node.js project setup"
    ;;
  *)
    info "Unknown profile: $PROFILE_NAME — ran base install only"
    ;;
esac

# ─── Summary ─────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}"
cat << 'DONE'
    ┌─────────────────────────────────────────┐
    │          Bootstrap complete!              │
    │                                          │
    │   Restart your terminal to apply         │
    │   all changes (or: exec zsh)             │
    └─────────────────────────────────────────┘
DONE
echo -e "${RESET}"

echo -e "  ${DIM}Next steps:${RESET}"
echo -e "  1. Restart terminal or run: ${BOLD}exec zsh${RESET}"
echo -e "  2. Choose the ${BOLD}Dotfiles${RESET} profile in iTerm2"
echo -e "  3. Run: ${BOLD}gh auth login${RESET}"
echo -e "  4. Run: ${BOLD}bash scripts/check.sh${RESET} to verify"
echo ""
echo -e "  ${DIM}Re-run anytime — safe to repeat.${RESET}"
echo ""
