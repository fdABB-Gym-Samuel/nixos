{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../home-modules/hyprland.nix
  ];

  home.packages = with pkgs; [
    kitty
    firefox
  ];

  home.stateVersion = "26.05";
}
