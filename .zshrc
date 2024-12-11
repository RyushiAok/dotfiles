if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [ `uname` != "Darwin" ]; then
    # Java
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
    export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# # pyenv (nvim)
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# CUDA
if [ -d "/usr/local/cuda-12.5" ]; then
    export PATH="/usr/local/cuda-12.5/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda-12.5/lib64:$LD_LIBRARY_PATH"
fi

# zsh parameter completion for the dotnet CLI
_dotnet_zsh_complete() {
    local completions=("$(dotnet complete "$words")")
    # If the completion list is empty, just continue with filename selection
    if [ -z "$completions" ]; then
        _arguments '*::arguments: _normal'
        return
    fi
    # This is not a variable assignment, don't remove spaces!
    _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"
