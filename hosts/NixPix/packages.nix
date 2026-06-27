{
  input,
  pkgs,
  ...
}:
{
  services.tailscale = {
    enable = true;
    authKeyFile = "/home/regnm0ln1/.config/tailscale/regnm0ln1.key";
  };

  services.displayManager.ly = {
    enable = false;
    settings = {
      animation = "gameoflife";
      clock = "%c";
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

  # ly crawls its `custom_sessions` dir (default /etc/ly/custom-sessions) on top
  # of the wayland/x session dirs. NixOS never creates it, so ly prints the
  # harmless "failed to crawl session directories" message on the greeter.
  # Create an empty one to silence it (cosmetic — not related to login failures).
  #environment.etc."ly/custom-sessions/.keep".text = "";

  programs.zsh.enable = true;
}
