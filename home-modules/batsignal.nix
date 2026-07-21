{ config, pkgs, ... }:

{
  services.batsignal = {
    enable = true;
    extraArgs = [
      "-w"
      "25" # warning at 25%
      "-c"
      "10" # critical at 10%
      "-d"
      "5" # danger (custom action) at 5%
      "-f"
      "0" # disable "battery full" notification (0 = off)
    ];
  };

}
