{ ... }:
{
  # Battery life: CPU energy profiles, Intel thermal management, and powertop's
  # device-level tunings (runtime PM, USB autosuspend, ...) applied at boot.
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;

  # Idle handling for every home-manager user on the host: dim, lock,
  # screen off, then suspend.
  home-manager.sharedModules = [
    {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 150;
              on-timeout = "brightnessctl -s set 10%";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 330;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 900;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
    }
  ];
}
