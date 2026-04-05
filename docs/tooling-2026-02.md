# Terminal Tooling Shortlist (as of February 13, 2026)

This list focuses on tools that improve shell UX on both macOS and WSL.

## High-value defaults
- `zoxide`: smarter `cd` using frecency and shell integration.
  Source: https://github.com/ajeetdsouza/zoxide
- `fzf`: fuzzy finder for files/history/processes.
  Source: https://github.com/junegunn/fzf
- `ripgrep (rg)`: fast recursive search.
  Source: https://github.com/BurntSushi/ripgrep
- `fd`: friendly `find` replacement.
  Source: https://github.com/sharkdp/fd
- `eza`: modern `ls` replacement.
  Source: https://github.com/eza-community/eza
- `bat`: `cat` with syntax highlighting.
  Source: https://github.com/sharkdp/bat
- `git-delta`: improved git diffs.
  Source: https://github.com/dandavison/delta

## Worth adding next
- `atuin`: encrypted shell history sync and better history search.
  Source: https://atuin.sh/
- `mise`: polyglot runtime/version manager (Node, Python, etc.).
  Source: https://mise.jdx.dev/
- `uv`: very fast Python package/project manager.
  Source: https://docs.astral.sh/uv/
- `zellij`: modern terminal multiplexer (alternative to tmux).
  Source: https://zellij.dev/
- `yazi`: fast terminal file manager.
  Source: https://github.com/sxyazi/yazi

## Windows/WSL UX tools
- Windows Terminal (font, opacity, profile management):
  Source: https://learn.microsoft.com/windows/terminal/
- Nerd Fonts for prompt/icon compatibility:
  Source: https://www.nerdfonts.com/

## Recommendation for your setup
1. Keep your current zsh + powerlevel10k workflow for continuity.
2. Standardize on `zoxide`, `fzf`, `eza`, `bat`, `fd`, `rg`, and `delta` everywhere.
3. Add `atuin` if you want synced history across Mac + WSL.
4. Add `mise` if you want one runtime manager across both environments.
5. Add `uv` for Python-heavy work.
