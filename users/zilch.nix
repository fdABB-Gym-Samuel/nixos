{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  sandbox = inputs.depot.legacyPackages.${pkgs.system}.sandbox;
in
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
    ../home-modules/ssh.nix
    ../home-modules/qsbar.nix
  ];

  home.packages =
    (with pkgs; [
      kitty
      firefox
      onlyoffice-desktopeditors

      fastfetch

      slurp
      grim

      wireguard-tools
      proton-vpn

      podman
      podman-compose

      signal-desktop

      inputs.nvim.packages.${pkgs.system}.default

      prismlauncher
    ])
    ++ (with sandbox; [
      claude-code
    ]);
  home.shellAliases = {
    v = lib.mkForce "${inputs.nvim.packages.x86_64-linux.default}/bin/nvim";
  };
  home.stateVersion = "26.05";
}
