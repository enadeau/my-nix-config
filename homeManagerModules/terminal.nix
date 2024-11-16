{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    terminal.enable = lib.mkEnableOption "enable kitty";
  };

  config = lib.mkIf config.terminal.enable {
    programs.kitty.enable = true;
    programs.kitty.package = config.lib.nixGL.wrap pkgs.kitty;
    programs.kitty.keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+n" = "new_os_window_with_cwd";
    };
    programs.kitty.settings = {
      confirm_os_window_close = 0;
    };
  };
}
