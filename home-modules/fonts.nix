{ config, pkgs, ... }:

{
  fonts = {
    fontconfig = {
      enable = true;
      antialiasing = true;
      subpixelRendering = "none";
      defaultFonts = {
        serif = [
          "Source Serif Pro"
          "Liberation Serif"
        ];
        sansSerif = [
          "Inter"
        ];
        monospace = [
          "Iosevka Nerd Font"
        ];
      };
    };
  };

}
