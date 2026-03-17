. "$HOME/.cargo/env"



export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/dev/builds/flutter/bin
# export PATH=$PATH:$HOME/dev/builds/Android/cmdline-tools/latest/bin
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_AVD_HOME=$HOME/.config/.android/avd
export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
# export PATH=$PATH:$HOME/Android/Sdk/emulator

export CHROME_EXECUTABLE=$(which firefox)
# export STUDIO_VM_OPTIONS="--enable-features=UseOzonePlatform --ozone-platform=wayland"

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

export EDITOR='nvim'

# export ANDROID_HOME=$HOME/dev/builds/Android

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"


