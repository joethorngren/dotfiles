# macOS Inventory - 2026-06-20

Snapshot source: LightHouse Keeper 2 (`/Users/oh_henry`) during the MacBook
onboarding pass. Secrets, auth files, local databases, SSH keys, and app support
data are intentionally not committed here.

## Canonical macOS restore list

Use `macos/Brewfile` for every Homebrew-installable Mac dependency we want
tracked:

```bash
brew bundle --file macos/Brewfile
```

That file now covers:

- Homebrew taps, formulae, and casks from this machine.
- Desktop apps called out during onboarding, including Wispr Flow and Blender.
- AI coding tools: Claude Code, Codex, Gemini, OpenClaw, Browserbase, MobileNext,
  Playwright MCP, and opencode.
- Mobile stack: Android Studio, Android command-line/platform tools, CocoaPods,
  Gradle, EAS, Firebase, Maestro PATH support, Java 17, and iOS device tooling.
- Bun via the official installer when `bun` is missing.
- Infra/dev CLIs: gcloud, Render, Vercel, Terraform, Cloudflare tunnel,
  Tailscale, rclone, PostgreSQL 16, MySQL client, libpq, Docker Desktop.
- Media/docs/ML helpers: Ollama, whisper-cpp, ffmpeg, yt-dlp, poppler, pandoc,
  chafa, llmfit, Blender, PrusaSlicer.
- VS Code/Cursor extensions currently installed: `anysphere.remote-ssh`,
  `openai.chatgpt`.

`scripts/bootstrap-macos.sh` runs `brew install --cask --adopt` for apps that
already exist in `/Applications` but are not yet Homebrew-owned, then applies the
full Brewfile.

## Additional apps found on this Mac

These were present in `/Applications` and are represented in `macos/Brewfile`
where a Homebrew cask exists:

- AeroSpace
- Android Studio
- Anki
- Bartender
- Blender
- CalDigit Docking Station Utility
- ChatGPT
- Claude
- Codex
- Cursor
- Discord
- Docker Desktop
- Firefox
- Ghostty
- Google Chrome
- Google Chrome Beta
- Google Drive
- iTerm2 and iTermAI
- Keyboard Maestro
- Moom
- Obsidian
- Ollama
- PrusaSlicer
- Shottr
- Signal
- Slack
- SoundSource
- T3 Code
- Tailscale
- Telegram
- Vysor
- Wispr Flow

## Manual or review-before-install items

These were found locally but do not currently have a safe normal Brewfile entry:

- Zyzzyva: installed locally, but no Homebrew cask was found.
- Google Docs, Sheets, and Slides apps: likely Chrome/PWA installs, not casks.
- UniFi OS Server: local app exists. The nearest Homebrew cask is
  `ubiquiti-unifi-controller`, but it is deprecated and requires Rosetta, so
  install manually only if still needed.
- CalDigit Docking Station Utility and Google Chrome Beta are in
  `macos/Brewfile`, but this existing Mac needs an interactive sudo-capable run
  to adopt or reinstall them under Homebrew ownership.
- App auth/state: Google Drive, Tailscale, Docker, ChatGPT, Claude, Cursor,
  Codex, iTermAI, Keyboard Maestro, Obsidian, Wispr Flow, and SoundSource all
  need post-install sign-in or settings sync.
- `~/.openclaw`, `~/.claude`, `~/.codex`, `~/.ssh`, `~/.secrets.env`, and
  similar local config/state directories should be restored from 1Password,
  encrypted backup, or their own private repos, not committed here.

## Current known gaps / follow-up checks

- Maestro itself is not installed by Homebrew here; the shell config only adds
  `~/.maestro/bin` when present. Reinstall with the official installer if a fresh
  Mac does not have it.
- Google Admin Manager (`~/bin/gam7/gam`) is referenced by an alias when present,
  but the binary is not committed or installed by this repo.
- Rosetta is not installed by this bootstrap. Avoid adding Intel-only casks until
  there is a clear reason.
- Lighthouse/Linux should use this repo only for shared shell/git/tmux config;
  GPU drivers, CUDA, and ML stack belong in the Lighthouse setup repo.
