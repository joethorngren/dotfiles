# Keep this lightweight; it runs for every zsh invocation.

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Prefer user bin early
export PATH="$HOME/.local/bin:$PATH"

# Rust/Cargo, if installed by rustup.
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Android SDK is needed by some non-interactive mobile tooling.
if [ -z "${ANDROID_SDK_ROOT:-}" ]; then
  if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
  elif [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
  fi
fi

if [ -n "${ANDROID_SDK_ROOT:-}" ]; then
  export PATH="$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools"
fi
