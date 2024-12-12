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
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    pkgs.nixd
    pkgs.nixfmt-rfc-style
    pkgs.git
    pkgs.gh
    pkgs.neovim
    pkgs.tailscale
    pkgs.ripgrep
    pkgs.lazygit
    pkgs.gcc
    pkgs.go
    pkgs.terraform
    pkgs.starship
    pkgs.volta
    pkgs.typst
    pkgs.sccache
    pkgs.ruff-lsp
    pkgs.pyenv
    pkgs.poetry
    pkgs.zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-completions
  ];

  # enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/takashi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
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

    initExtra = ''
      # https://github.com/microsoft/terminal/issues/755#issuecomment-530905894
      setopt no_beep
      setopt auto_cd #一致するディレクトリに cdなしで移動できる
      setopt correct #コマンドのスペルを修正(正しい可能性のある候補を表示)
      setopt correct_all #コマンドラインの引数のスペルを修正
      setopt hist_ignore_dups #直前と同じコマンドは履歴に追加しない
      setopt share_history  #他のzshで履歴を共有する
      setopt inc_append_history #即座に履歴を保存する

      bindkey -e
      # Control + backspace
      bindkey '^H' backward-kill-word
      bindkey '\[3\;5~' kill-word
      # Control + arrows
      bindkey ";5C" forward-word
      bindkey ";5D" backward-word

      alias ze='zellij'
      alias zef='zellij plugin -- filepicker'

      # starship
      eval "$(starship init zsh)"
    '';
  };
}
