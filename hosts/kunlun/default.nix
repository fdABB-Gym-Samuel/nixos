{ ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./bluetooth.nix
    ../../modules/laptop-power.nix
  ];

  # Stop charging at 90% to slow battery wear while keeping most of the runtime.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT*", TEST=="charge_control_end_threshold", ATTR{charge_control_end_threshold}="90"
  '';

  system.stateVersion = "25.11";
}
