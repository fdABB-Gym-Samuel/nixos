{ inputs, ... }:
{
  imports = [ inputs.quickshell-bar.homeManagerModules.default ];

  programs.catppuccinBar = {
    enable = true;
    installFonts = true; # JetBrainsMono Nerd Font
    # Launched from Hyprland via exec-once instead of a systemd service.
    systemd.enable = false;
  };
}
