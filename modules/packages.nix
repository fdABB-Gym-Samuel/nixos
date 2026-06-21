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
