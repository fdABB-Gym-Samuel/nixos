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
    ../home-modules/fonts.nix
    ../home-modules/icons.nix
    ../home-modules/xdg.nix
    ../home-modules/swaync.nix
    ../home-modules/batsignal.nix
  ];

  home.packages = with pkgs; [
    kitty
    firefox

    fastfetch

    slurp
    grim

    wireguard-tools
    proton-vpn

    podman
    podman-compose

    signal-desktop
  ];

  home.stateVersion = "26.05";
}
