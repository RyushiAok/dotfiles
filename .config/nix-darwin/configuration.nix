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
  imports = [
    ./packages.nix
    ./shell.nix
    ./homebrew.nix
  ];

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
