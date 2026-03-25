{
  input,
  pkgs,
  ...
}:
{
  services.tailscale = {
    enable = true;
    authKeyFile = "/home/zilch/.config/tailscale/zilch.key";
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "gameoflife";
      clock = "%c";
      battery_id = "BAT0";
      bigclock_12hr = false;
      bigclock_seconds = true;
      gameoflife_entropy_interval = 10;
      gameoflife_fg = "0x00FF00FF";
      gameoflife_initial_density = 0.25;
      gameoflife_frame_delay = 5;
      hide_version_string = true;
      show_password_key = "F7";
    };
  };

  services.upower = {
    enable = true;
    usePercentageForPolicy = true;
    percentageLow = 25;
    percentageCritical = 10;
    percentageAction = 5;
    criticalPowerAction = "Hibernate"; # or "PowerOff" / "HybridSleep"
  };

  programs.zsh.enable = true;
}
