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

  # https://search.nixos.org/options
  home.packages = with pkgs; [
    gcc
    ripgrep
    pkg-config
    sccache
    tailscale
    act

    # typst
    typst
    tinymist

    # python
    ruff
    pyenv
    poetry

    # git
    gh
    lefthook
    ghq
    fzf

    # nix
    nixd
    nixfmt-rfc-style

    # fonts
    cascadia-code
    nerd-fonts.caskaydia-cove
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nix.package = pkgs.nix;

  home.file = {
    ".config/karabiner".source = ../karabiner;
    ".config/nvim".source = ../nvim;
    ".config/pypoetry".source = ../pypoetry;
    ".config/zellij".source = ../zellij;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  # https://search.nixos.org/options
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
    lfs = {
      enable = true;
    };
  };
  programs.lazygit = {
    enable = true;
  };
  programs.zsh = {
    # https://home-manager-options.extranix.com/?query=zsh
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    history = {
      append = true;
      ignoreAllDups = true;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 10000;
      size = 10000;
      share = true;
    };

    historySubstringSearch = {
      enable = true;
    };

    shellAliases = {
      ze = "zellij";
      zef = "zellij plugin -- filepicker";
    };

    envExtra = ''
      . "$HOME/.cargo/env"
      if [ -d "/usr/local/cuda-12.5" ]; then
          export PATH="/usr/local/cuda-12.5/bin:$PATH"
          export LD_LIBRARY_PATH="/usr/local/cuda-12.5/lib64:$LD_LIBRARY_PATH"
      fi
      export PATH="$HOME/.dotnet/tools:$PATH"
      export GHQ_ROOT="$HOME/repo"
    '';

    autocd = true;
    initContent = ''
      setopt no_beep
      setopt correct            # コマンドのスペルを修正(正しい可能性のある候補を表示)
      setopt correct_all        # コマンドラインの引数のスペルを修正 

      # https://github.com/microsoft/terminal/issues/755#issuecomment-530905894
      bindkey -e
      # Control + backspace
      bindkey '^H' backward-kill-word
      bindkey '\[3\;5~' kill-word
      # Control + arrows
      bindkey ';5C' forward-word
      bindkey ';5D' backward-word

      ghq-jump-widget() {
        local repo
        repo=$(ghq list -p | fzf --height 50% --reverse --prompt="ghq> ") || return
        BUFFER="cd $repo"
        zle accept-line
      }
      zle -N ghq-jump-widget
      bindkey '^[g' ghq-jump-widget # Alt-g
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

  programs.zellij = {
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  fonts.fontconfig.enable = true;
}
