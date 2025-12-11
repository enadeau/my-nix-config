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
    git.userName = lib.mkOption {
      type = lib.types.str;
      default = "Émile Nadeau";
      description = "Name use for git commit";
    };
  };

  config = lib.mkIf config.git.enable {
    programs.git.enable = true;
    programs.git.settings.user.email = config.git.userEmail;
    programs.git.settings.user.name = config.git.userName;
    programs.git.settings.alias = {
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
    ];
    programs.difftastic = {
      enable = false;
      git.enable = true;
    };
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
    programs.git.settings = {
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

    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          email = config.git.userEmail;
          name = config.git.userName;
        };
      };
    };
  };
}
