{
  pkgs,
  lib,
  config,
  ...
}: let
  aliases = lib.attrNames config.home.shellAliases;
  create_line = alias: "complete -F _complete_alias ${alias}\n";
  lines = lib.concatStrings (map create_line aliases);
in {
  config = {
    programs.bash.bashrcExtra = ''
      # Enable auto-completion on aliases
      source ${pkgs.complete-alias}/bin/complete_alias
      ${lines}
    '';
  };
}
