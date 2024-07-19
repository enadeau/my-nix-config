{
  lib,
  config,
  pkgs,
  ...
}: let
  colors = config.lib.stylix.colors;
  reduce_backlight = device_name: {
    timeout = 240;
    # set monitor backlight to minimum, avoid 0 on OLED monitor.
    on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -d ${device_name} -s set 10%";
    # monitor backlight restore.
    on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -d ${device_name} -r";
  };
in {
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 2;
      gaps_out = 2;
      border_size = 1;
      layout = "master";
    };
    decoration = {
      rounding = 2;
    };
    animations = {
      enabled = true;
    };
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };
    master = {
      new_on_active = "after";
    };
    input = {
      kb_layout = "ca";
      kb_variant = "fr";
    };
    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, P, exec, rofi -show drun -show-icons"
      "$mainMod_SHIFT, RETURN, exec, kitty"
      "$mainMod, I, exec, firefox"
      "$mainMod_SHIFT, C, killactive,"
      "$mainMod_SHIFT, Q, exit,"
      "$mainMod, T, togglefloating,"
      "$mainMod, SPACE, layoutmsg, orientationcycle left top"
      "$mainMod_SHIFT, Z, exec, hyprlock"
      # Move focus
      "$mainMod, j, layoutmsg, cyclenext"
      "$mainMod, k, layoutmsg, cycleprev"
      # Move window
      "bind = $mainMod_SHIFT, j, layoutmsg, swapnext"
      "bind = $mainMod_SHIFT, k, layoutmsg, swapprev"
      "bind = $mainMod, RETURN, layoutmsg, swapwithmaster"
      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"
    ];

    binde = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances."
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };
      listener = [
        # Reduce backlight after 4 min
        (reduce_backlight "intel_backlight")
        (reduce_backlight "ddcci2")
        # Lock screen after 5min
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # Screen off after  5.5min
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # Suspend pc after 30min
        # {
        #   timeout = 1800;
        #   on-timeout = "systemctl suspend";
        # }
      ];
    };
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };
      input-field = {
        monitor = "";
        size = "250, 60";
        outline_thickness = 1;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgb(${colors.base02})";
        inner_color = "rgb(${colors.base01})";
        font_color = "rgb(${colors.base04})";
        check_color = "rgb(${colors.base0A})";
        fail_color = "rgb(${colors.base08})";
        fade_on_empty = false;
        placeholder_text = ''
          <i>Input Password...</i>
        '';
        hide_input = false;
        position = "0, -50";
        halign = "center";
        valign = "center";
        zindex = 2;
      };
      shape = {
        monitor = "";
        size = "600, 300";
        color = "rgb(${colors.base00})";
        rounding = 10;
        border_size = 4;
        border_color = "rgb(${colors.base0D})";
        shadow_passes = 5;
        shadow_size = 10;
        rotate = 0;
        position = "0, 30";
        halign = "center";
        valign = "center";
        zindex = 1;
      };
      # TIME
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%-I:%M%p")"'';
          color = "rgb(${colors.base05})";
          font_size = 120;
          font_family = "NotoSans Nerd Font ExtraBold";
          position = "0, 0";
          halign = "center";
          valign = "center";
          zindex = 2;
        }
        {
          monitor = "";
          text = "<span>󰌾 </span>";
          color = "rgb(${colors.base05})";
          font_size = 50;
          font_family = "NotoSans Nerd Font ExtraBold";
          position = "-175, -40";
          halign = "center";
          valign = "center";
          zindex = 3;
        }
      ];
      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };
    };
  };

  wayland.windowManager.hyprland.settings.exec-once = [
    "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent &"
    "${pkgs.waybar}/bin/waybar > ~/logs/waybar.log 2>&1 &"
    "${pkgs.hypridle}/bin/hypridle > ~/logs/hypridle.log 2>&1 &"
    "${pkgs.hyprpaper}/bin/hyprpaper &"
  ];
}
