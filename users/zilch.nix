{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../home-modules/hyprland.nix
    ../home-modules/kitty.nix
  ];

  home.packages = with pkgs; [
    kitty
    firefox
  ];

  home.stateVersion = "26.05";
}
