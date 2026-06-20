# Terminal Tooling Shortlist (refreshed June 20, 2026)

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

## Current workstation additions
- `uv`: fast Python package/project manager; now installed and used for
  `notebooklm-mcp-cli`.
  Source: https://docs.astral.sh/uv/
- `opencode`, `claude`, `codex`, and `gemini`: terminal AI coding tools.
- `firebase`, `gcloud`, `vercel`, `eas`, and `clerk`: app/platform CLIs used
  by the current Mac setup.
- `android-commandlinetools`, `android-platform-tools`, `android-studio`,
  `openjdk@17`, and `maestro`: Android/mobile automation setup.
- `ghostty`, `iterm2`, `aerospace`, `moom`, `keyboard-maestro`, and
  `tailscale`: terminal, windowing, automation, and network workflow.

## Worth adding next
- `mise`: polyglot runtime/version manager (Node, Python, etc.).
  Source: https://mise.jdx.dev/
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
3. Keep `uv` as the default Python package runner for this workstation.
4. Add `mise` if you want one runtime manager across both environments.
5. Revisit `atuin` only if synced shell history becomes a real need.
