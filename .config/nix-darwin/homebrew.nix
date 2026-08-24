{ user, ... }:
{
  homebrew = {
    enable = true;
    inherit user;
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
}
