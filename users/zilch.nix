{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../home-modules/hyprland.nix
    ../home-modules/kitty.nix
    ../home-modules/hyprlock.nix
    ../home-modules/zsh.nix
    ../home-modules/cursor.nix
  ];

  home.packages = with pkgs; [
    kitty
    firefox

    slurp
    grim
  ];

  home.stateVersion = "26.05";
}
