{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  # The hyprland config is shared across hosts, so the monitor layout is
  # selected per-host from the NixOS hostname. `wallpaperMonitor` is the primary
  # display the wallpaper-cycle keybind acts on; `wallpaperMonitorSecondary` is
  # the optional second display (null on single-monitor hosts).
  hostMonitors = {
    nixpix = {
      monitors = [
        # Primary: MSI MAG272CQR (2560x1440@164.8Hz) at the origin.
        "DP-3, 2560x1440@164.80, 0x0, 1"
        # Secondary: MSI MAG241CR (1920x1080) to the right, tops aligned (y=0).
        "HDMI-A-1, 1920x1080@144, 2560x0, 1"
      ];
      wallpaperMonitor = "DP-3";
      wallpaperMonitorSecondary = "HDMI-A-1";
    };
    blizzard = {
      monitors = [ "eDP-1, preferred, 0x0, 0.83" ];
      wallpaperMonitor = "eDP-1";
      wallpaperMonitorSecondary = null;
    };
    kunlun = {
      monitors = [ "eDP-1, preferred, 0x0, 1" ];
      wallpaperMonitor = "eDP-1";
      wallpaperMonitorSecondary = null;
    };
  };
  host = hostMonitors.${osConfig.networking.hostName};
in
{
  home.packages = with pkgs; [
    libnotify
    wl-clipboard
    grim
    slurp
    playerctl
    brightnessctl
  ];
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.configType = "hyprlang";
  wayland.windowManager.hyprland.settings = {
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
    "$vpn" = "protonvpn-app";

    monitor = host.monitors;

    "exec-once" =
    [
      "${config.home.homeDirectory}/.config/nixos/util_scripts/hyprpaper_iterator.sh ${host.wallpaperMonitor} --current"
      "$vpn"
      # Chinese (Pinyin) input method daemon; toggle with Ctrl+Space.
      "fcitx5 -d --replace"
      "catppuccin-bar"
    ]
    # On multi-monitor hosts, also set the secondary monitor's wallpaper at startup.
    ++
      lib.optional (host.wallpaperMonitorSecondary != null)
        "${config.home.homeDirectory}/.config/nixos/util_scripts/hyprpaper_iterator.sh ${host.wallpaperMonitorSecondary} --current";

    general = {
      gaps_in = 10;
      gaps_out = "6, 30, 30, 30";
      border_size = 2;

      "col.active_border" = "rgba(780fadff)";
      "col.inactive_border" = "rgba(31297a55)";

      resize_on_border = false;

      allow_tearing = false;

      layout = "dwindle";
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
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };

    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
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
        natural_scroll = true;
      };
    };

    device = {
      name = "epic-mouse-v1";
      sensitivity = -0.5;
    };

    bind = [
      "$mainMod, T, exec, $terminal"
      "$mainMod, B, exec, $browser"
      "$mainMod, F, exec, $fileManager"
      "$mainMod, Return, exec, $menu"
      "$SUPER, N, exec, swaync-client -t -sw"
      "$mainMod, G, exec, steam"
      "$mainMod, S, exec, $music"
      "$mainMod, P, exec, $signal"
      "$mainMod, C, exec, $editor"
      "$mainMod, O, exec, $office"
      "$mainMod, L, exec, $lock"
      "$mainMod SHIFT, C, exec, $editor_conf"
      "$mainMod, X, killactive,"
      "$mainMod SHIFT ALT CTRL, M, exit,"
      "$mainMod, I, exec, $vpn"

      "$mainMod SHIFT, S, exec, FILE=$HOME/images/screenshots/$(date +%Y-%m-%d_%H:%M:%S).png && grim -g \"$(slurp)\" \"$FILE\" && wl-copy < \"$FILE\" && notify-send -i \"$FILE\" \"Screenshot\" \"Saved to $FILE\""

      "$mainMod, V, togglefloating,"
      "$mainMod, R, exec, $menu"
      "$mainMod, J, layoutmsg, togglesplit"
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

      "SHIFT CTRL ALT, Right, exec, $HOME/.config/nixos/util_scripts/hyprpaper_iterator.sh ${host.wallpaperMonitor}"

      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ]
    # On multi-monitor hosts, the same shortcut without SHIFT cycles the
    # wallpaper on the secondary monitor.
    ++
      lib.optional (host.wallpaperMonitorSecondary != null)
        "CTRL ALT, Right, exec, $HOME/.config/nixos/util_scripts/hyprpaper_iterator.sh ${host.wallpaperMonitorSecondary}"
    # Multi-monitor only: move the current workspace to the monitor left/right.
    ++ lib.optionals (host.wallpaperMonitorSecondary != null) [
      "$mainMod SHIFT, left, movecurrentworkspacetomonitor, l"
      "$mainMod SHIFT, right, movecurrentworkspacetomonitor, r"
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
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n0 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n0 set 5%-"
    ];

    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    windowrule = [
      "suppress_event maximize, match:class = .*"

      "match:focus = false,match:class = ^$,match:title = ^$,match:xwayland = 1,match:float = 1,match:fullscreen = 0, match:pin = 0"

      "workspace 1, match:class Code"
      "workspace 2, match:class $browser"
      "workspace 3, match:class $terminal"

      "workspace 4, match:class ONLYOFFICE"

      "workspace 5, match:class steam"

      "workspace 5, match:class cs2"
      "fullscreen on, match:class cs2"

      "workspace 6, match:class Spotify"

      "workspace 7, match:class gimp"
      "workspace 7, match:class onlyoffice"

      "workspace 8, match:class $fileManager"
      "workspace 9, match:class signal"

      "workspace special:minimize silent, match:class proton.vpn.app.gtk"
    ];
  };

  services.hyprpaper.enable = true;
  services.hyprpaper.settings.splash = false;
  programs.hyprlock.enable = true;
}
