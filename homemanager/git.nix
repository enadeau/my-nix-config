{
  lib,
  config,
  ...
}: {
  options = {
    git.enable = lib.mkEnableOption "enable git";
    git.userEmail = lib.mkOption {
      type = lib.types.str;
      default = "nadeau.emile@gmail.com";
      description = "Email address to use for git commits";
    };
  };

  config = lib.mkIf config.git.enable {
    programs.git.enable = true;
    programs.git.userEmail = config.git.userEmail;
    programs.git.userName = "Émile Nadeau";
    programs.git.aliases = {
      d = "diff";
      st = "status --short --branch";
      co = "checkout";
      ci = "commit";
      br = "branch";
      wdiff = "diff --color-words";
      cdiff = "diff --cached";
      gr = "log --graph --full-history --all --color --pretty=tformat:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s%x20%x1b[33m(%an)%x1b[0m\"";
    };
    programs.git.ignores = [
      "*~"
      "*.swp"
      ".python-version"
    ];
    programs.git.diff-so-fancy.changeHunkIndicators = true;
    programs.git.extraConfig = {
      push = {
        push = "simple";
      };
      color = {
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        status = "auto";
      };
    };

    home.shellAliases.g = "git";
    programs.bash.bashrcExtra = ''
      # Autocompletion for g alias
      source $HOME/.nix-profile/share/git/contrib/completion/git-completion.bash
      __git_complete g __git_main
    '';
  };
}
