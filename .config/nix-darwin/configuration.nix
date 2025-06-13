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
    direnv
    starship
    mise
    tailscale

    # git
    git
    git-lfs
    gh
    lazygit

    # shell
    starship
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions

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
      eval "$($(which mise) activate zsh)"
      eval "$(direnv hook zsh)"
      eval "$(starship init zsh)"
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
