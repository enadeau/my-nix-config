{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    mystylix.enable = lib.mkEnableOption "enable stylix";
  };

  config = lib.mkIf config.mystylix.enable {
    stylix = {
      enable = true;
      enableReleaseChecks = true;
      # Having issue getting gnome to start. Just handpicking the target for now
      autoEnable = false;
      targets = {
        btop.enable = true;
        kitty.enable = true;
        dunst.enable = false; # This seems to be the problematic target for booting gnome
        nixvim.enable = true;
        starship.enable = true;
        rofi.enable = false; # Needs fixing quite ugly over terminal
        waybar.enable = false;
        firefox.enable = false;
      };
      image = pkgs.runCommand "wallpaper_1920x1080.jpg" {} ''
        ${pkgs.imagemagick}/bin/convert ${./wallpaper_full_resolution.jpg} \
        -resize 1920x1080! \
        -filter Lanczos \
        -sharpen 0x1 \
        $out
      '';
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
      # fonts = {
      #   serif = {
      #     package = pkgs.dejavu_fonts;
      #     name = "DejaVu Serif";
      #   };
      #   sansSerif = {
      #     package = pkgs.dejavu_fonts;
      #     name = "DejaVu Sans";
      #   };
      #   monospace = {
      #     package = pkgs.nerd-fonts.fira-code;
      #     name = "FiraCode Nerd Font Mono";
      #   };
      #   emoji = {
      #     package = pkgs.noto-fonts-emoji;
      #     name = "Noto Color Emoji";
      #   };
      # };
      # cursor = {
      #   name = "Adwaita";
      #   package = pkgs.adwaita-icon-theme;
      #   size = 20;
      # };
    };
  };
}
