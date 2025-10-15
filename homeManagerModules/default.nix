{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./bash_alias_completion.nix
    ./dropbox.nix
    ./git.nix
    ./terminal.nix
    ./mystylix.nix
    ./aws/default.nix
    # ./waybar.nix
    # ./hyprland.nix
  ];

  config = {
    home.stateVersion = "23.11"; # Please read the comment before changing.
    programs.home-manager.enable = true;

    programs.bat.enable = true;

    programs.ripgrep.enable = true;
    programs.firefox.enable = true;
    programs.firefox.package = config.lib.nixGL.wrap pkgs.firefox;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
    };
    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "keyboard";
          gap_size = 5;
          frame_width = 1;
          corner_radius = 10;
          stack_duplicates = false;
          notification_limit = 4;
          progress_bar = true;
          progress_bar_corner_radius = 5;
        };
      };
    };
    # xdg.portal = {
    #   enable = true;
    #   config.common.default = "*";
    #   extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    # };

    nixpkgs.config.allowUnfree = true;
    home.packages = [
      pkgs.tldr
      pkgs.curl
      pkgs.keepassxc
      pkgs.obsidian
      pkgs.claude-code
      pkgs.codex
      pkgs.just
    ];

    home.sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };

    home.sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
      "$HOME/.cabal/bin"
      "$HOME/.cargo/bin"
    ];

    home.shellAliases = {
      grep = "grep --color=auto";
      ls = "ls --color=auto";
      ll = "ls --all -l --classify";
    };

    programs.bash.enable = true;

    programs.readline = {
      enable = true;
      includeSystemConfig = false;
      variables = {
        completion-ignore-case = true;
        show-all-if-ambiguous = true;
      };
      bindings = {
        # Shift-tab to flip trough autocompletion matches
        "\\e[Z" = "menu-complete";
        # Filtered history search
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
      };
    };

    dropbox.enable = true;
    git.enable = true;
    aws.enable = true;
    terminal.enable = true;
    # waybar.enable = true;

    programs.btop.enable = true;
    programs.starship.enable = true;
    programs.nixvim = import ../nixvim // {enable = true;};

    mystylix.enable = true;
  };
}
