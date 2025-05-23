{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    go
    mise
    uv
    ruff
    pyenv
    poetry
    typst
    sccache

    neovim
    gcc
    ripgrep
    tailscale
    direnv

    # git
    git
    git-lfs
    gh
    lazygit

    #
    pkg-config

    # nix
    nixd
    nixfmt-rfc-style

    # shell
    starship
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions

    # fonts
    cascadia-code
    nerd-fonts.caskaydia-cove
  ];

  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".config/karabiner".source = ../karabiner;
    ".config/nvim".source = ../nvim;
    ".config/nix".source = ../nix;
    ".config/pypoetry".source = ../pypoetry;
    ".config/zellij".source = ../zellij;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.git = {
    enable = true;
    userName = "RyushiAok";
    userEmail = "55625375+RyushiAok@users.noreply.github.com";
    ignores = [
      "**/.envrc"
      "**/.direnv/"
    ];
  };
  programs.zsh = {
    # https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    history = {
      ignoreAllDups = true;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 10000;
      size = 10000;
      share = true;
    };

    historySubstringSearch = {
      enable = true;
    };

    envExtra = ''
      . "$HOME/.cargo/env"
    '';

    initContent = ''
      if [ -d "/usr/local/cuda-12.5" ]; then
          export PATH="/usr/local/cuda-12.5/bin:$PATH"
          export LD_LIBRARY_PATH="/usr/local/cuda-12.5/lib64:$LD_LIBRARY_PATH"
      fi
      eval "$(direnv hook zsh)"
      setopt no_beep
      setopt auto_cd #一致するディレクトリに cdなしで移動できる
      setopt correct #コマンドのスペルを修正(正しい可能性のある候補を表示)
      setopt correct_all #コマンドラインの引数のスペルを修正
      setopt hist_ignore_dups #直前と同じコマンドは履歴に追加しない
      setopt share_history  #他のzshで履歴を共有する
      setopt inc_append_history #即座に履歴を保存する

      # https://github.com/microsoft/terminal/issues/755#issuecomment-530905894
      bindkey -e
      # Control + backspace
      bindkey '^H' backward-kill-word
      bindkey '\[3\;5~' kill-word
      # Control + arrows
      bindkey ";5C" forward-word
      bindkey ";5D" backward-word

      alias ze='zellij'
      alias zef='zellij plugin -- filepicker'

      eval "$($(which mise) activate zsh)"

      # starship
      eval "$(starship init zsh)"
    '';

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];
  };

  fonts.fontconfig.enable = true;
}
