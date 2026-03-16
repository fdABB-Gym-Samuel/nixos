{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.enable = true;
  wayalnd.windowManager.hyprland.settigns = {
    "$mainMod" = "SUPER";
    "$terminal" = "kitty";
    "$browser" = "firefox";
    "$fileManager" = "nemo";
    "$menu" = "wofi --show drun";
    "$editor" = "code";
    "$office" = "onlyoffice-desktopeditors";
    "$editor_conf" = "code ~/projects/dotfiles";
    "$music" = "spotify";
    "$signal" = "signal-desktop";
    "$lock" = "hyprlock";

    monitor = ["HDMI-A-1, preferred,0x0, 1"];

    general = {
      gaps_in = 10;
      gaps_out = 50;
      border_size = 2;

      "col.active_border" = "rgba(780fadff)";
      "col.active_border" = "rgba(780fadff)";
      "col.inactive_border" = "rgba(31297a55)";
      "col.inactive_border" = "rgba(31297a55)";

      resize_on_border = false;

      allow_tearing = false;

      layout = dwindle;
    };

    decoration = {
      rounding = 3;
      rounding_power = 10;

      active_opacity = 1;
      inactive_opacity = 1;

      shadow = {
        enabled = false;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };

      blur = {
        enabled = true;
        size = 2;
        passes = 3;

        vibrancy = 0.1696;
      };
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };

    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = false;
    };

    cursor = {
      inactive_timeout = "5s";
    };

    input = {
      kb_layout = "se";
      kb_variant = "nodeadkeys";

      follow_mouse = 1;

      sensitivity = 0;

      touchpad = {
        natural_scroll = false;
      };
    };

    device = {
      name = epic-mouse-v1;
      sensitivity = -0.5;
    };

    bind = [
      "$mainMod, T, exec, $terminal"
      "$mainMod, B, exec, $browser"
      "$mainMod, F, exec, $fileManager"
      "$mainMod, Return, exec, $menu"
      "$UPER, N, exec, swaync-client -t -sw"
      "$mainMod, G, exec, steam"
      "$mainMod, S, exec, $music"
      "$mainMod, P, exec, $signal"
      "$mainMod, C, exec, $editor"
      "$mainMod, O, exec, $office"
      "$mainMod, L, exec, $lock"
      "$mainMod SHIFT, C, exec, $editor_conf"
      "$mainMod, X, killactive,"
      "$mainMod SHIFT ALT CTRL, M, exit,"

      "$mainMod, V, togglefloating,"
      "$mainMod, R, exec, $menu"
      "$mainMod, J, togglesplit, dwindle"
      "$mainMod, M, togglespecialworkspace, minimize"
      "$mainMod SHIFT, M, movetoworkspace, special:minimize"

      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

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

      "$mainMod, KP_End, workspace, 1"
      "$mainMod, KP_Down, workspace, 2"
      "$mainMod, KP_Next, workspace, 3"
      "$mainMod, KP_Left, workspace, 4"
      "$mainMod, KP_Begin, workspace, 5"
      "$mainMod, KP_Right, workspace, 6"
      "$mainMod, KP_Home, workspace, 7"
      "$mainMod, KP_Up, workspace, 8"
      "$mainMod, KP_Prior, workspace, 9"
      "$mainMod, KP_Insert, workspace, 10"

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

      "$mainMod SHIFT, KP_End, movetoworkspace, 1"
      "$mainMod SHIFT, KP_Down, movetoworkspace, 2"
      "$mainMod SHIFT, KP_Next, movetoworkspace, 3"
      "$mainMod SHIFT, KP_Left, movetoworkspace, 4"
      "$mainMod SHIFT, KP_Begin, movetoworkspace, 5"
      "$mainMod SHIFT, KP_Right, movetoworkspace, 6"
      "$mainMod SHIFT, KP_Home, movetoworkspace, 7"
      "$mainMod SHIFT, KP_Up, movetoworkspace, 8"
      "$mainMod SHIFT, KP_Prior, movetoworkspace, 9"
      "$mainMod SHIFT, KP_Insert, movetoworkspace, 10"

      "$mainMod SHIFT, Left, movecurrentworkspacetomonitor, l"
      "$mainMod SHIFT, Right, movecurrentworkspacetomonitor, r"

      "SHIFT CTRL ALT, Right, exec, ~/projects/dotfiles/bash/hyprpaper_iterator.sh"
      "CONTROL ALT, Right, exec, ~/projects/dotfiles/bash/hyprpaper_iterator.sh HDMI-A-1"

      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
      "$mainMod SHIFT, mouse:272, resizewindow"
    ];

    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };

  programs.hyprlock.enable = true;
}
