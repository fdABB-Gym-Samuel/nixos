{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    papirus-icon-theme
  ];

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style = {
      name = "qt6ct";
      package = pkgs.papirus-icon-theme;
    };
    qt6ctSettings = {
      Appearance = {
        style = "kvantum";
        icon_theme = "Papirus-Dark";
        standar_dialogs = "xdgdesktopportal";
      };
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

}
