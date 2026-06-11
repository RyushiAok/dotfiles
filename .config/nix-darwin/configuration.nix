{ pkgs, user, ... }:
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
    awscli2
    aws-vault
    ssm-session-manager-plugin

    # shell
    mise
    starship
    direnv
    fd
    fzf
    ripgrep
    yazi
    zellij
    zsh-autosuggestions
    zsh-syntax-highlighting

    # git
    git
    git-lfs
    gh
    ghq
    lazygit
    lefthook
    delta

    # terraform / infra
    terraform
    terraform-ls
    atlas

    # editor / tools
    neovim
    helix
    aria2
    marp-cli
    mint
    mysql84
    pkg-config

    # # network
    # tailscale

    # nix
    nixd
    nixfmt-rfc-style
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
      ghq-jump-widget() {
        local repo
        repo=$({ ghq list -p; } | fzf --height 50% --reverse --prompt="ghq> ") || return
        BUFFER="cd $repo"
        zle accept-line
      }
      zle -N ghq-jump-widget
      bindkey '^f' ghq-jump-widget # Ctrl-f

      unsetopt correct correctall
    '';
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
  };

  homebrew = {
    enable = true;
    user = user;
    onActivation = {
      cleanup = "uninstall";
      extraFlags = [ "--force-cleanup" ];
    };
    casks = [
      "beekeeper-studio"
      "claude-code"
      "cursor"
      "drawio"
      "figma"
      "ghostty"
      "gitify"
      "karabiner-elements"
      "notion"
      "session-manager-plugin"
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
}
