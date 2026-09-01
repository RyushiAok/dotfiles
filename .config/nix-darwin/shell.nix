{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';
    interactiveShellInit = ''
      export OP_BIOMETRIC_UNLOCK_ENABLED=true
      eval "$(mise activate zsh)"
      eval "$(mise activate --shims)"

      [[ -x /opt/homebrew/bin/brew ]] && {
        export HOMEBREW_PREFIX="/opt/homebrew"
        export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
        export HOMEBREW_REPOSITORY="/opt/homebrew"
        case ":$PATH:" in *":/opt/homebrew/bin:"*)  ;; *) export PATH="$PATH:/opt/homebrew/bin"  ;; esac
        case ":$PATH:" in *":/opt/homebrew/sbin:"*) ;; *) export PATH="$PATH:/opt/homebrew/sbin" ;; esac
      }

      export GHQ_ROOT="$HOME/repo"
      export DOTNET_ROOT="${pkgs.dotnet-sdk_10}/share/dotnet"
      export DOTNET_ROOT_ARM64="$DOTNET_ROOT"
      export PATH="$HOME/.dotnet/tools:$PATH"

      ghq-jump-widget() {
        local repo
        repo=$({ ghq list -p; echo "$HOME/.agents"; } | fzf --height 50% --reverse --prompt="ghq> ") \
          || { zle reset-prompt; return; }
        BUFFER="cd $repo"
        zle reset-prompt
        zle accept-line
      }
      zle -N ghq-jump-widget
      bindkey '^f' ghq-jump-widget

      ghq-copy-path-widget() {
        local repo
        repo=$({ ghq list -p; echo "$HOME/.agents"; } | fzf --height 50% --reverse --prompt="ghq (copy)> ") \
          || { zle reset-prompt; return; }
        echo -n "$repo" | pbcopy
        zle reset-prompt
      }
      zle -N ghq-copy-path-widget
      bindkey '^y' ghq-copy-path-widget

      unsetopt correct correctall

      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';
  };

  environment.shellAliases = {
    ze = "zellij";
    zef = "zellij plugin -- filepicker";
  };
}
