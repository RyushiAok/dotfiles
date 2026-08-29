{ config, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "RyushiAok";
      email = "55625375+RyushiAok@users.noreply.github.com";
    };
    ignores = [
      "**/.claude/settings.local.json"
      "**/.envrc"
      "**/.direnv/"
      "**/.tmp/"
      "**/.serena/"
      "**/.DS_STORE"
    ];
    lfs.enable = true;
  };

  programs.lazygit.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    history = {
      append = true;
      ignoreAllDups = true;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 10000;
      size = 10000;
      share = true;
    };
    historySubstringSearch.enable = true;
    shellAliases = {
      ze = "zellij";
      zef = "zellij plugin -- filepicker";
    };
    envExtra = ''
      . "$HOME/.cargo/env"
      export PATH="$HOME/.elan/bin:$PATH"
      if [ -d "/usr/local/cuda-13.0" ]; then
        export PATH="/usr/local/cuda-13.0/bin:$PATH"
        export LD_LIBRARY_PATH="/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH"
      fi
      export LD_LIBRARY_PATH="${
        pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
          pkgs.libxcrypt
        ]
      }:$LD_LIBRARY_PATH"
      export C_INCLUDE_PATH="${pkgs.lib.makeSearchPath "include" [ pkgs.libxcrypt ]}:$C_INCLUDE_PATH"
      export LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.libxcrypt ]}:$LIBRARY_PATH"
      export PKG_CONFIG_PATH="${
        pkgs.lib.makeSearchPath "lib/pkgconfig" [ pkgs.libxcrypt ]
      }:$PKG_CONFIG_PATH"
      export DOTNET_ROOT="${config.home.sessionVariables.DOTNET_ROOT}"
      export PATH="$HOME/.dotnet/tools:$PATH"
      export GHQ_ROOT="$HOME/repo"
      export PATH="$HOME/.local/bin:$PATH"
    '';
    autocd = true;
    initContent = ''
      setopt no_beep

      unsetopt correct
      unsetopt correct_all

      # https://github.com/microsoft/terminal/issues/755#issuecomment-530905894
      bindkey -e
      # Control + backspace
      bindkey '^H' backward-kill-word
      bindkey '\[3\;5~' kill-word
      # Control + arrows
      bindkey ';5C' forward-word
      bindkey ';5D' backward-word

      ghq-jump-widget() {
        local repo
        repo=$({ ghq list -p; echo "$HOME/dotfiles"; } | fzf --height 50% --reverse --prompt="ghq> ") || return
        BUFFER="cd $repo"
        zle accept-line
      }
      zle -N ghq-jump-widget
      bindkey '^[g' ghq-jump-widget # Alt-g
    '';
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };

  programs.zellij.enableZshIntegration = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };
}
