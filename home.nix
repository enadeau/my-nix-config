{ lib, config, pkgs, ... }:

let
  completionDir = "${config.home.homeDirectory}/.local/share/bash-completion/completions";
  dropboxModule = import ./dropbox.nix { inherit pkgs lib config completionDir; };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "emilen";
  home.homeDirectory = "/home/emilen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.ripgrep
    pkgs.firefox
    pkgs.slack
    pkgs.tldr
    pkgs.curl
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
  ];

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
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/emilen/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BASH_COMPLETION_USER_DIR = completionDir;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    dropboxModule
  ];

  dropbox.enable = true;
  git.enable = true;

  programs.btop.enable = true;
  programs.btop.settings = {
    theme_background = false;
    color_theme = "solarized_dark";
  };

  programs.starship.enable = true;
}
