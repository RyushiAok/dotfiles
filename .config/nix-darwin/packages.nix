{ outputs, pkgs, ... }:
{
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

    # 1password
    _1password-cli

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
    outputs.packages.${pkgs.stdenv.hostPlatform.system}.atlas-standard
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
}
