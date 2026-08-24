{ pkgs, user, ... }:
let
  gitIgnore = pkgs.writeText "git-ignore" ''
    **/.claude/settings.local.json
    **/.envrc
    **/.direnv/
    **/.tmp/
    **/.serena/
    **/.DS_STORE
  '';
in
{

  system.stateVersion = 5;

  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = true;
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
    };
  };

  system = {
    startup.chime = false;
    defaults = {
      NSGlobalDomain.AppleShowAllExtensions = true;
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };
      dock = {
        autohide = true;
        show-recents = false;
        orientation = "bottom";
      };
    };
  };

  # https://github.com/nix-darwin/nix-darwin/blob/master/modules/examples/flake/flake.nix
  environment.systemPackages = with pkgs; [
    # aws
    aws-vault
    awscli2
    ssm-session-manager-plugin

    # shell
    direnv
    mise
    starship
    zsh-autosuggestions
    zsh-syntax-highlighting

    # cli
    aria2
    fd
    fzf
    herdr
    jq
    ripgrep
    tree
    yazi
    zellij

    # git
    act
    delta
    gh
    ghq
    git
    git-lfs
    lazygit
    lefthook

    # terraform / infra
    atlas
    tenv
    terraform-ls
    tflint

    # editors / language tools
    helix
    neovim
    tinymist

    # docs
    marp-cli
    mint

    # database
    mysql84
    redis

    # runtime
    dotnet-sdk_10
    pkg-config

    # nix
    nh
    nixd
    nixfmt

    # network
    # tailscale
  ];

  programs.direnv = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';
    interactiveShellInit = ''
      eval "$(mise activate zsh)"
      eval "$(mise activate --shims)"
      # eval "$(rbenv init - zsh)"
      if [ -x /opt/homebrew/bin/brew ]; then
        export HOMEBREW_PREFIX="/opt/homebrew"
        export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
        export HOMEBREW_REPOSITORY="/opt/homebrew"
        case ":$PATH:" in *":/opt/homebrew/bin:"*) ;; *) export PATH="$PATH:/opt/homebrew/bin" ;; esac
        case ":$PATH:" in *":/opt/homebrew/sbin:"*) ;; *) export PATH="$PATH:/opt/homebrew/sbin" ;; esac
      fi
      export GHQ_ROOT="$HOME/repo"
      export DOTNET_ROOT="${pkgs.dotnet-sdk_10}/share/dotnet"
      export DOTNET_ROOT_ARM64="$DOTNET_ROOT"
      export PATH="$HOME/.dotnet/tools:$PATH"
      ghq-jump-widget() {
        local repo
        repo=$({ ghq list -p; echo "$HOME/.agents"; } | fzf --height 50% --reverse --prompt="ghq> ") || return
        BUFFER="cd $repo"
        zle accept-line
      }
      zle -N ghq-jump-widget
      bindkey '^f' ghq-jump-widget # Ctrl-f

      unsetopt correct correctall

      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';
  };

  environment.shellAliases = {
    ze = "zellij";
    zef = "zellij plugin -- filepicker";
  };

  homebrew = {
    enable = true;
    user = user;
    onActivation = {
      cleanup = "uninstall";
      extraFlags = [ "--force-cleanup" ];
    };
    casks = [
      "1password"
      "beekeeper-studio"
      "claude-code"
      "cursor"
      "drawio"
      "figma"
      "ghostty"
      "gitify"
      "karabiner-elements"
      "notion"
      "visual-studio-code"
      "xcodes-app"
    ];
    brews = [ ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };

  system.activationScripts.postActivation.text = ''
    mkdir -p /Users/${user}/.config/git
    install -m 644 ${gitIgnore} /Users/${user}/.config/git/ignore
    chown ${user}:staff /Users/${user}/.config/git/ignore
  '';
}
