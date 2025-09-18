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
    mise
    zellij

    # aws
    awscli2
    aws-vault
    ssm-session-manager-plugin

    # git
    git
    git-lfs
    gh
    lazygit
    lefthook
    ghq
    fzf

    # shell
    starship

    # network
    tailscale

    # nix
    nixd
    nixfmt-rfc-style
  ];

  programs.direnv = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellInit = ''
      eval "$(mise activate zsh)"
      eval "$(mise activate --shims)"
      eval "$(direnv hook zsh)"
      eval "$(starship init zsh)"
      eval "$(rbenv init - zsh)"

      export GHQ_ROOT="$HOME/repo"
      ghq-jump-widget() {
        local repo
        repo=$({ ghq list -p; echo "$HOME/dotfiles"; } | fzf --height 50% --reverse --prompt="ghq> ") || return
        BUFFER="cd $repo"
        zle accept-line
      }
      zle -N ghq-jump-widget
      bindkey '^f' ghq-jump-widget # Ctrl-f

      unsetopt correct correctall
    '';
  };

  homebrew = {
    enable = true;
    user = user;
    casks = [
      "visual-studio-code"
      "cursor"
      "xcodes"
      "raycast"
      "warp"
    ];
    brews = [
      "mint"
      "neovim"
      "aria2"
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };
}
