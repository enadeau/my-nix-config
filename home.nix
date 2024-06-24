{ lib, config, pkgs, openconnect-sso, ... }:

let
  completionDir = "${config.home.homeDirectory}/.local/share/bash-completion/completions";
  dropboxModule = import ./dropbox.nix { inherit pkgs lib config completionDir; };
in
{
  home.username = "emilen";
  home.homeDirectory = "/home/emilen";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;

  programs.ripgrep.enable = true;
  programs.firefox.enable = true;
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
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.slack
    pkgs.tldr
    pkgs.curl
    pkgs.keepassxc
    openconnect-sso.packages.x86_64-linux.default
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BASH_COMPLETION_USER_DIR = completionDir;
  };

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


  imports = [
    ./git.nix
    ./waybar.nix
    ./terminal.nix
    dropboxModule
  ];

  dropbox.enable = true;
  git.enable = true;
  waybar.enable = true;

  programs.btop.enable = true;
  programs.starship.enable = true;

  stylix = {
    enable = true;
    image = ./wallpaper_full_resolution.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
    fonts = {
        serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.fira-code-nerdfont;
        name = "FiraCode Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets = {
      hyprland.enable = false;
      rofi.enable = false; # Needs fixing quite ugly over terminal
      waybar.enable = false;
    };
  };
}
