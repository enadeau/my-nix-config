{
  programs.kitty.enable = true;
  programs.kitty.keybindings = {
    "ctrl+c" = "copy_or_interrupt";
    "ctrl+v" = "past_from_clipboard";
    "ctrl+shift+n" = "new_os_window_with_cwd";
  };
  programs.kitty.settings = {
    confirm_os_window_close = 0;
    # background_opacity = "0.95";
  };
}
