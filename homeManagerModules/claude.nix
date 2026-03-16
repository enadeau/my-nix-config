{pkgs, ...}: {
  home.packages = [pkgs.claude-code];

  home.file.".claude/CLAUDE.md".source = ./claude.md;

  # TODO: still needs to find a way to include the token properly
  # programs.mcp = {
  #   enable = true;
  #   servers = {
  #     sentry = {
  #       command = "npx";
  #       args = [
  #         "@sentry/mcp-server@latest"
  #       ];
  #       env = {
  #         SENTRY_ACCESS_TOKEN = "REPLACE_WITH_SENTRY_TOKEN";
  #       };
  #     };
  #   };
  # };
}
