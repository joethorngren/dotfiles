# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Cross-platform Zsh config for macOS + WSL/Linux
# Keep machine-specific overrides in ~/.zshrc.local (not committed)

# Skip the p10k configuration wizard — we ship our own .p10k.zsh
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

setopt prompt_subst

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

# Platform detection
case "$(uname -s)" in
  Darwin*) DOTFILES_PLATFORM="macos" ;;
  Linux*)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      DOTFILES_PLATFORM="wsl"
    else
      DOTFILES_PLATFORM="linux"
    fi
    ;;
  *) DOTFILES_PLATFORM="unknown" ;;
esac
export DOTFILES_PLATFORM

# Paths
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# Homebrew paths (Apple Silicon first)
[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
[ -d "/usr/local/bin" ] && export PATH="/usr/local/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"

# Java (optional per-host)
[ -n "$JAVA_HOME" ] && export PATH="$JAVA_HOME/bin:$PATH"

# oh-my-zsh
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Completions and integrations
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -f "$HOME/.openclaw/completions/openclaw.zsh" ] && source "$HOME/.openclaw/completions/openclaw.zsh"

# Modern CLI tool integrations
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
[ -f "/opt/homebrew/opt/fzf/shell/completion.zsh" ] && source "/opt/homebrew/opt/fzf/shell/completion.zsh"
[ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ] && source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

# iTerm2 integration on macOS only
if [ "$DOTFILES_PLATFORM" = "macos" ] && [ -f "$HOME/.iterm2_shell_integration.zsh" ]; then
  source "$HOME/.iterm2_shell_integration.zsh"
fi

# p10k prompt if present
[ -f "$HOME/.p10k.zsh" ] && source "$HOME/.p10k.zsh"

# Secrets (never commit)
[ -f "$HOME/.secrets.env" ] && source "$HOME/.secrets.env"

# Optional machine-local overrides
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Better defaults when modern tools exist
command -v eza >/dev/null 2>&1 && alias ls='eza --group-directories-first'
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
command -v rg >/dev/null 2>&1 && alias grep='rg'

# Suppress "update available" nags from CLI tools that self-update.
# These tools check their registry on every invocation and nag even
# after you've already updated. Disable the check — update explicitly
# with `upgrade-all` instead.
export CLAUDE_DISABLE_UPDATE_CHECK=1
export CODEX_DISABLE_UPDATE_CHECK=1

# Unified upgrade command — one alias to rule them all
upgrade-all() {
  echo "── Homebrew ──"
  brew update && brew upgrade && brew cleanup
  echo ""
  echo "── Claude Code ──"
  if command -v claude >/dev/null 2>&1; then
    claude update 2>/dev/null || npm update -g @anthropic-ai/claude-code 2>/dev/null || echo "manual update needed"
  fi
  echo ""
  echo "── Codex CLI ──"
  if command -v codex >/dev/null 2>&1; then
    brew upgrade --cask codex 2>/dev/null || echo "already latest"
  fi
  echo ""
  echo "── npm globals ──"
  npm update -g 2>/dev/null || true
  echo ""
  echo "── Done ──"
}
