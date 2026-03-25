{ ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./bluetooth.nix
  ];

  system.stateVersion = "25.11";
}
