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
      image = pkgs.runCommand "wallpaper_1920x1080.jpg" {} ''
        ${pkgs.imagemagick}/bin/convert ${../homemanager/wallpaper_full_resolution.jpg} \
        -resize 1920x1080! \
        -filter Lanczos \
        -sharpen 0x1 \
        $out
      '';
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
    };
  };
}
