{ config, pkgs, ... }:

{
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

  home.packages = with pkgs; [
    neovim
    gcc
    ripgrep
    tailscale
    direnv

    # git
    git
    gh
    lazygit

    # nix
    nixd
    nixfmt-rfc-style

    # shell
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    starship

    # fonts
    cascadia-code
    nerd-fonts.caskaydia-cove
  ];

  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".config/karabiner".source = ../karabiner;
    ".config/nvim".source = ../nvim;
    ".config/nix".source = ../nix;
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.git = {
    enable = true;
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

    initExtra = ''
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

      # starship
      eval "$(starship init zsh)"
    '';
  };

  fonts.fontconfig.enable = true;
}
