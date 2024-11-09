{
  lib,
  config,
  pkgs,
  username,
  inputs,
  ...
}: let
  completionDir = "${config.home.homeDirectory}/.local/share/bash-completion/completions";
  dropboxModule = import ./dropbox.nix {inherit pkgs lib config completionDir;};
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./git.nix
    ../modules/mystylix.nix
    # ./waybar.nix
    ./terminal.nix
    # ./hyprland.nix
    dropboxModule
  ];

  config = {
    home.username = username;
    home.homeDirectory = "/home/${username}";
    home.stateVersion = "23.11"; # Please read the comment before changing.
    programs.home-manager.enable = true;

    programs.ripgrep.enable = true;
    programs.firefox.enable = true;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
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
      pkgs.slack
      pkgs.tldr
      pkgs.curl
      pkgs.keepassxc
    ];

    home.sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      BASH_COMPLETION_USER_DIR = completionDir;
    };

    home.sessionPath = [
      "$HOME/.cabal/bin"
      "$HOME/bin"
      "$HOME/cargo/bin"
      "$HOME/.local/bin"
    ];

    home.shellAliases = {
      grep = "grep --color=auto";
      ls = "ls --color=auto";
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
    # waybar.enable = true;

    programs.btop.enable = true;
    programs.starship.enable = true;
    programs.nixvim = import ../nixvim // {enable = true;};

    mystylix.enable = true;
    stylix.targets = {
      rofi.enable = false; # Needs fixing quite ugly over terminal
      waybar.enable = false;
    };
  };
}
