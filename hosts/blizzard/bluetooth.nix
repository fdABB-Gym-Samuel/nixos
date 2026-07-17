{
  config,
  pkgs,
  lib,
  ...
}:

{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  systemd.user.services.blueman-applet.serviceConfig.ExecStart = lib.mkForce [
    "" # clears inherited ExecStart
    "${pkgs.blueman}/bin/blueman-applet"
  ];
}
