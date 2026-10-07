{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;

  # The hyprland config is shared across hosts, so the monitor layout is
  # selected per-host from the NixOS hostname. `wallpaperMonitor` is the primary
  # display the wallpaper-cycle keybind acts on; `wallpaperMonitorSecondary` is
  # the optional second display (null on single-monitor hosts).
  hostMonitors = {
    nixpix = {
      monitors = [
        # Primary: MSI MAG272CQR (2560x1440@164.8Hz) at the origin.
        {
          output = "DP-3";
          mode = "2560x1440@164.80";
          position = "0x0";
          scale = 1;
        }
        # Secondary: MSI MAG241CR (1920x1080) to the right, tops aligned (y=0).
        {
          output = "HDMI-A-1";
          mode = "1920x1080@144";
          position = "2560x0";
          scale = 1;
        }
      ];
      wallpaperMonitor = "DP-3";
      wallpaperMonitorSecondary = "HDMI-A-1";
    };
    blizzard = {
      monitors = [
        {
          output = "eDP-1";
          mode = "preferred";
          position = "0x0";
          scale = 0.83;
        }
      ];
      wallpaperMonitor = "eDP-1";
      wallpaperMonitorSecondary = null;
    };
    kunlun = {
      monitors = [
        {
          output = "eDP-1";
          mode = "preferred";
          position = "0x0";
          scale = 1;
        }
      ];
      wallpaperMonitor = "eDP-1";
      wallpaperMonitorSecondary = null;
    };
  };
  host = hostMonitors.${osConfig.networking.hostName};
  multiMonitor = host.wallpaperMonitorSecondary != null;

  mainMod = "SUPER";
  terminal = "kitty";
  browser = "firefox";
  fileManager = "nemo";
  menu = "wofi --show drun";
  editor = "code";
  office = "onlyoffice-desktopeditors";
  editorConf = "code ~/projects/dotfiles";
  music = "spotify";
  signal = "signal-desktop";
  lock = "hyprlock";
  vpn = "protonvpn-app";

  wallpaperScript = "${config.home.homeDirectory}/.config/nixos/util_scripts/hyprpaper_iterator.sh";

  # Renders a Nix string as a quoted, escaped Lua string literal.
  luaStr = lib.generators.toLua { };

  # hl.bind(keys, dispatcher[, opts]); the dispatcher is a raw Lua expression.
  mkBind = keys: dispatcher: { _args = [ keys (mkLuaInline dispatcher) ]; };
  mkBindWith = opts: keys: dispatcher: { _args = [ keys (mkLuaInline dispatcher) opts ]; };
  exec = cmd: "hl.dsp.exec_cmd(${luaStr cmd})";

  # Old bindel/bindl flags: e = repeating, l = locked (works on the lockscreen).
  mkBindel = mkBindWith {
    repeating = true;
    locked = true;
  };
  mkBindl = mkBindWith { locked = true; };
  # Old bindm: mouse-drag binds.
  mkBindm = mkBindWith { mouse = true; };

  # Keypad keys for workspaces 1-10, in workspace order.
  kpKeys = [
    "KP_End"
    "KP_Down"
    "KP_Next"
    "KP_Left"
    "KP_Begin"
    "KP_Right"
    "KP_Home"
    "KP_Up"
    "KP_Prior"
    "KP_Insert"
  ];

  # mainMod + [0-9 / keypad digit] focuses workspace 1-10,
  # with SHIFT it moves the active window there instead.
  workspaceBinds = lib.concatLists (
    map (
      i:
      let
        num = toString (lib.mod i 10);
        kp = builtins.elemAt kpKeys (i - 1);
        ws = toString i;
      in
      [
        (mkBind "${mainMod} + ${num}" "hl.dsp.focus({ workspace = ${ws} })")
        (mkBind "${mainMod} + ${kp}" "hl.dsp.focus({ workspace = ${ws} })")
        (mkBind "${mainMod} + SHIFT + ${num}" "hl.dsp.window.move({ workspace = ${ws} })")
        (mkBind "${mainMod} + SHIFT + ${kp}" "hl.dsp.window.move({ workspace = ${ws} })")
      ]
    ) (lib.range 1 10)
  );

  screenshotCmd = ''FILE=$HOME/images/screenshots/$(date +%Y-%m-%d_%H:%M:%S).png && grim -g "$(slurp)" "$FILE" && wl-copy < "$FILE" && notify-send -i "$FILE" "Screenshot" "Saved to $FILE"'';

  startupCommands = [
    "${wallpaperScript} ${host.wallpaperMonitor} --current"
  ]
  # On multi-monitor hosts, also set the secondary monitor's wallpaper at startup.
  ++ lib.optional multiMonitor "${wallpaperScript} ${host.wallpaperMonitorSecondary} --current"
  ++ [
    vpn
    # Chinese (Pinyin) input method daemon; toggle with Ctrl+Space.
    "fcitx5 -d --replace"
    "catppuccin-bar"
  ];
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
  wayland.windowManager.hyprland.configType = "lua";
  wayland.windowManager.hyprland.settings = {
    monitor = map (m: { _args = [ m ]; }) host.monitors;

    # signal-desktop's nixpkgs wrapper no longer handles NIXOS_OZONE_WL;
    # Electron >= 28 reads this variable natively instead. Without it Electron
    # apps run under XWayland and their content doesn't track the tiled window
    # size on fractionally scaled monitors.
    env = [
      { _args = [ "ELECTRON_OZONE_PLATFORM_HINT" "auto" ]; }
      { _args = [ "NIXOS_OZONE_WL" "1" ]; }
    ];

    # exec-once equivalent: run once when hyprland starts.
    on = {
      _args = [
        "hyprland.start"
        (mkLuaInline (
          "function()\n" + lib.concatMapStrings (cmd: "  hl.exec_cmd(${luaStr cmd})\n") startupCommands + "end"
        ))
      ];
    };

    config = {
      general = {
        gaps_in = 10;
        gaps_out = {
          top = 6;
          right = 30;
          bottom = 30;
          left = 30;
        };
        border_size = 2;

        col = {
          active_border = "rgba(780fadff)";
          inactive_border = "rgba(31297a55)";
        };

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
        inactive_timeout = 5;
      };

      # Render remaining XWayland apps (e.g. steam) at scale 1 so their content
      # matches the window size on fractionally scaled monitors.
      xwayland = {
        force_zero_scaling = true;
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
    };

    device = {
      name = "epic-mouse-v1";
      sensitivity = -0.5;
    };

    bind = [
      (mkBind "${mainMod} + T" (exec terminal))
      (mkBind "${mainMod} + B" (exec browser))
      (mkBind "${mainMod} + F" (exec fileManager))
      (mkBind "${mainMod} + Return" (exec menu))
      (mkBind "${mainMod} + N" (exec "swaync-client -t -sw"))
      (mkBind "${mainMod} + G" (exec "steam"))
      (mkBind "${mainMod} + S" (exec music))
      (mkBind "${mainMod} + P" (exec signal))
      (mkBind "${mainMod} + C" (exec editor))
      (mkBind "${mainMod} + O" (exec office))
      (mkBind "${mainMod} + L" (exec lock))
      (mkBind "${mainMod} + SHIFT + C" (exec editorConf))
      (mkBind "${mainMod} + X" "hl.dsp.window.close()")
      (mkBind "${mainMod} + SHIFT + ALT + CTRL + M" "hl.dsp.exit()")
      (mkBind "${mainMod} + I" (exec vpn))

      (mkBind "${mainMod} + SHIFT + S" (exec screenshotCmd))

      (mkBind "${mainMod} + V" ''hl.dsp.window.float({ action = "toggle" })'')
      (mkBind "${mainMod} + R" (exec menu))
      (mkBind "${mainMod} + J" ''hl.dsp.layout("togglesplit")'')
      (mkBind "${mainMod} + M" ''hl.dsp.workspace.toggle_special("minimize")'')
      (mkBind "${mainMod} + SHIFT + M" ''hl.dsp.window.move({ workspace = "special:minimize" })'')

      (mkBind "${mainMod} + left" ''hl.dsp.focus({ direction = "left" })'')
      (mkBind "${mainMod} + right" ''hl.dsp.focus({ direction = "right" })'')
      (mkBind "${mainMod} + up" ''hl.dsp.focus({ direction = "up" })'')
      (mkBind "${mainMod} + down" ''hl.dsp.focus({ direction = "down" })'')

      (mkBind "SHIFT + CTRL + ALT + Right" (exec "${wallpaperScript} ${host.wallpaperMonitor}"))

      (mkBind "${mainMod} + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
      (mkBind "${mainMod} + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')

      # Old bindm section: move/resize windows by dragging with the mouse.
      (mkBindm "${mainMod} + mouse:272" "hl.dsp.window.drag()")
      (mkBindm "${mainMod} + mouse:273" "hl.dsp.window.resize()")
      (mkBindm "${mainMod} + SHIFT + mouse:272" "hl.dsp.window.resize()")

      # Old bindel section: repeat while held, work on the lockscreen.
      (mkBindel "XF86AudioRaiseVolume" (exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
      (mkBindel "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
      (mkBindel "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
      (mkBindel "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
      (mkBindel "XF86MonBrightnessUp" (exec "brightnessctl -e4 -n0 set 5%+"))
      (mkBindel "XF86MonBrightnessDown" (exec "brightnessctl -e4 -n0 set 5%-"))

      # Old bindl section: work on the lockscreen.
      (mkBindl "XF86AudioNext" (exec "playerctl next"))
      (mkBindl "XF86AudioPause" (exec "playerctl play-pause"))
      (mkBindl "XF86AudioPlay" (exec "playerctl play-pause"))
      (mkBindl "XF86AudioPrev" (exec "playerctl previous"))
    ]
    ++ workspaceBinds
    # On multi-monitor hosts, the same shortcut without SHIFT cycles the
    # wallpaper on the secondary monitor.
    ++ lib.optional multiMonitor (
      mkBind "CTRL + ALT + Right" (exec "${wallpaperScript} ${host.wallpaperMonitorSecondary}")
    )
    # Multi-monitor only: move the current workspace to the monitor left/right.
    ++ lib.optionals multiMonitor [
      (mkBind "${mainMod} + SHIFT + left" ''hl.dsp.workspace.move({ monitor = "l" })'')
      (mkBind "${mainMod} + SHIFT + right" ''hl.dsp.workspace.move({ monitor = "r" })'')
    ];

    window_rule = [
      {
        name = "suppress-maximize";
        match.class = ".*";
        suppress_event = "maximize";
      }

      # Fix dragging issues with empty XWayland floating windows.
      {
        name = "xwayland-no-focus";
        match = {
          class = "^$";
          title = "^$";
          xwayland = true;
          float = true;
          fullscreen = false;
          pin = false;
        };
        no_focus = true;
      }

      {
        name = "ws-editor";
        match.class = "(?i)code";
        workspace = "1";
      }
      {
        name = "ws-browser";
        match.class = browser;
        workspace = "2";
      }
      {
        name = "ws-terminal";
        match.class = terminal;
        workspace = "3";
      }

      {
        name = "ws-office";
        match.class = "ONLYOFFICE";
        workspace = "4";
      }

      {
        name = "ws-steam";
        match.class = "steam";
        workspace = "5";
      }

      {
        name = "ws-cs2";
        match.class = "cs2";
        workspace = "5";
        fullscreen = true;
      }

      {
        name = "ws-music";
        match.class = "Spotify";
        workspace = "6";
      }

      {
        name = "ws-gimp";
        match.class = "gimp";
        workspace = "7";
      }
      {
        name = "ws-office-lower";
        match.class = "onlyoffice";
        workspace = "7";
      }

      {
        name = "ws-files";
        match.class = fileManager;
        workspace = "8";
      }
      {
        name = "ws-signal";
        match.class = "(?i)signal(-desktop)?";
        workspace = "9";
      }

      {
        name = "vpn-minimized";
        match.class = "proton.vpn.app.gtk";
        workspace = "special:minimize silent";
      }
    ];
  };

  services.hyprpaper.enable = true;
  services.hyprpaper.settings.splash = false;
  programs.hyprlock.enable = true;
}
