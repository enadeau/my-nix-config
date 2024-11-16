{
  lib,
  config,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  options = {
    waybar.enable = lib.mkEnableOption "enable waybar";
  };

  config = lib.mkIf config.waybar.enable {
    home.file.".config/waybar/colors.css".text = ''
      @define-color base00 #${colors.base00};
      @define-color base01 #${colors.base01};
      @define-color base02 #${colors.base02};
      @define-color base03 #${colors.base03};
      @define-color base04 #${colors.base04};
      @define-color base05 #${colors.base05};
      @define-color base06 #${colors.base06};
      @define-color base07 #${colors.base07};
      @define-color base08 #${colors.base08};
      @define-color base09 #${colors.base09};
      @define-color base0A #${colors.base0A};
      @define-color base0B #${colors.base0B};
      @define-color base0C #${colors.base0C};
      @define-color base0D #${colors.base0D};
      @define-color base0E #${colors.base0E};
      @define-color base0F #${colors.base0F};
    '';
    programs.waybar = {
      enable = true;
      style = ./waybar.css;
      settings = {
        mainBar = {
          layer = "top";
          modules-left = ["hyprland/workspaces"];
          modules-center = ["clock"];
          modules-right = [
            "network"
            "cpu"
            "temperature"
            "memory"
            "hyprland/language"
            "pulseaudio"
            "tray"
          ];
          "hyprland/window" = {
            max-length = 50;
          };
          clock = {
            format = "{:%a, %d. %b  %H:%M}";
          };
          network = {
            format = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
            # "format-wifi": "󰖩 ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
            # "format-ethernet": "󰈀 ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
            format-disconnected = ""; # An empty format will hide the module.
            tooltip-format = "{essid} ({signalStrength}%)\n{ifname}\t{ipaddr}/{cidr}\ngateway\t{gwaddr}";
            max-length = 50;
            on-click = "nm-connection-editor";
          };
          cpu = {
            interval = 1;
            format = "  {icon0} {icon1} {icon2} {icon3}";
            max-length = 10;
            format-icons = [
              "<span color='#${colors.base0B}'>▁</span>"
              "<span color='#${colors.base0B}'>▂</span>"
              "<span color='#${colors.base0B}'>▃</span>"
              "<span color='#${colors.base0B}'>▄</span>"
              "<span color='#${colors.base0A}'>▅</span>"
              "<span color='#${colors.base0A}'>▆</span>"
              "<span color='#${colors.base09}'>▇</span>"
              "<span color='#${colors.base08}'>█</span>"
            ];
          };
          memory = {
            interval = 1;
            format = "  {}% ";
            max-length = 10;
          };
          "hyprland/language" = {
            format = "󰌓  {}";
            format-fr = "CA";
            keyboard-name = "at-translated-set-2-keyboard";
          };
          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "󰕿";
            format-icons = {
              headphone = "󰋋";
              default = ["󰖀" "󰕾"];
            };
            scroll-step = 1;
            on-click = "pavucontrol";
            ignored-sinks = ["Easy Effects Sink"];
          };
        };
      };
    };
  };
}
