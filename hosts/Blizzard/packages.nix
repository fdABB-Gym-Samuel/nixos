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

  programs.zsh.enable = true;
}
