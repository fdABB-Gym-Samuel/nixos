{...}: {
  imports = [
    ./hardware.nix
    ./packages.nix
  ];

  system.stateVersion = "25.11";
}
