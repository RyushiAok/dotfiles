{ pkgs, ... }:
{

  system.stateVersion = 5;
 
  nixpkgs.config.allowUnfree = true;

  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
    };
  };
  services.nix-daemon.enable = true;

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

  homebrew = {
    enable = true; 
    taps = [
      "homebrew/bundle"
    ];
    casks = [
    ];
    brews = [
      "mint"
    ];
  };
}
