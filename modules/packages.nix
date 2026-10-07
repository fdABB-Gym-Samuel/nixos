{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

  environment.systemPackages = with pkgs; [
    wget
    curl

    wl-clipboard

    hyprpaper
  ];

  programs.hyprland.enable = true;
  # Electron/Chromium apps (signal-desktop, vscode) run under XWayland without
  # these, which mis-sizes their content on fractionally scaled monitors.
  # NIXOS_OZONE_WL only affects nixpkgs wrappers that check it; newer packages
  # (signal-desktop) rely on Electron's native ELECTRON_OZONE_PLATFORM_HINT.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Samuel Olsson";
        email = "samuel.olsson@hitachigymnasiet.se";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
