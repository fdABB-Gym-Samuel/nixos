{ ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./bluetooth.nix
    ../../modules/laptop-power.nix
  ];

  # Stop charging at 80% to slow further battery wear (mostly used plugged in).
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT*", TEST=="charge_control_end_threshold", ATTR{charge_control_end_threshold}="80"
  '';

  system.stateVersion = "25.11";
}
