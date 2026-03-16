{ config, pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    hyprcursor.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

}
