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

# Android SDK / mobile automation (optional)
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
elif [ -d "$HOME/Android/Sdk" ]; then
  export ANDROID_HOME="$HOME/Android/Sdk"
fi

if [ -n "$ANDROID_HOME" ]; then
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
fi

# Java 17 for Android/Maestro tooling.
if [ -z "${JAVA_HOME:-}" ] && command -v brew >/dev/null 2>&1; then
  JAVA17_HOME="$(brew --prefix openjdk@17 2>/dev/null)/libexec/openjdk.jdk/Contents/Home"
  [ -d "$JAVA17_HOME" ] && export JAVA_HOME="$JAVA17_HOME"
fi
[ -n "${JAVA_HOME:-}" ] && export PATH="$JAVA_HOME/bin:$PATH"

# JetBrains Toolbox scripts
if [ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]; then
  export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi

# Maestro CLI
[ -d "$HOME/.maestro/bin" ] && export PATH="$PATH:$HOME/.maestro/bin"

# Optional machine-local overrides
[ -f "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
