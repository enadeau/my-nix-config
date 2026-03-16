{pkgs, ...}: {
  home.file.".claude/CLAUDE.md".source = ./claude.md;

  programs.claude-code = {
    enable = true;
    mcpServers = {
      sentry = {
        type = "http";
        url = "https://mcp.sentry.dev/mcp";
      };
      vercel = {
        type = "http";
        url = "https://mcp.vercel.com";
      };
    };
  };
}
