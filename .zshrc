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

# zsh
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# # source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# if type brew &>/dev/null; then
#     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
#     autoload -Uz compinit
#     compinit
# fi

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

# Rust
export RUSTC_WRAPPER=$(which sccache)

setopt no_beep
setopt auto_cd #一致するディレクトリに cdなしで移動できる
setopt correct #コマンドのスペルを修正(正しい可能性のある候補を表示)
setopt correct_all #コマンドラインの引数のスペルを修正
setopt hist_ignore_dups #直前と同じコマンドは履歴に追加しない
setopt share_history  #他のzshで履歴を共有する
setopt inc_append_history #即座に履歴を保存する
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# https://github.com/microsoft/terminal/issues/755#issuecomment-530905894
bindkey -e
# Control + backspace
bindkey '^H' backward-kill-word
bindkey '\[3\;5~' kill-word
# Control + arrows
bindkey ";5C" forward-word
bindkey ";5D" backward-word

alias ze='zellij'
alias zef='zellij plugin -- filepicker'

eval "$(starship init zsh)"
