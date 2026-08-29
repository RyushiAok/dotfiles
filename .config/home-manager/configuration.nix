{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./packages.nix
    ./shell.nix
  ];

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that this configuration is
  # compatible with. Do not change it without checking the release notes.
  home.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.package = pkgs.nix;

  home.file = {
    ".config/karabiner".source = ../karabiner;
    ".config/nvim".source = ../nvim;
    ".config/zellij".source = ../zellij;
  };

  home.sessionVariables.DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
    ];
    themes.autumn_night_transparent = {
      "inherits" = "autumn_night";
      "ui.background" = { };
    };
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 14d --keep-one";
    };
  };

  systemd.user.services.nh-clean.Service.Environment = lib.mkIf pkgs.stdenv.isLinux [
    "\"NIX_CONFIG=experimental-features = nix-command flakes\""
  ];

  fonts.fontconfig.enable = true;
}
