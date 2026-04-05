# Login-shell setup for macOS + WSL/Linux

case "$(uname -s)" in
  Darwin*)
    [ -x "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
    [ -x "/usr/local/bin/brew" ] && eval "$(/usr/local/bin/brew shellenv)"
    ;;
  Linux*)
    # Common local user bin locations
    [ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
    ;;
esac

# Android SDK (optional)
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
elif [ -d "$HOME/Android/Sdk" ]; then
  export ANDROID_HOME="$HOME/Android/Sdk"
fi

if [ -n "$ANDROID_HOME" ]; then
  export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
fi

# JetBrains Toolbox scripts
if [ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]; then
  export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi

# Optional machine-local overrides
[ -f "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
