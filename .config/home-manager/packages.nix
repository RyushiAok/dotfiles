{ outputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    ripgrep
    pkg-config
    sccache
    act
    dotnet-sdk_10
    tenv
    outputs.packages.${pkgs.stdenv.hostPlatform.system}.atlas-standard

    icu
    libxml2
    libxcrypt

    # aws
    awscli2
    aws-vault
    ssm-session-manager-plugin

    # typst
    typst
    tinymist

    # python
    ruff
    uv

    codex

    # git
    gh
    lefthook
    ghq
    fzf

    # nix
    nixd
    nixfmt

    # cli
    herdr

    # fonts
    cascadia-code
    nerd-fonts.caskaydia-cove
  ];
}
