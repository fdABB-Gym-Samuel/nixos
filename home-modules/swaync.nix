{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
  ];

  services.swaync = {
    enable = true;
    settings = {
      "$schema" = "/etc/xdg/swaync/configSchema.json";

      positionX = "right";
      positionY = "top";
      layer = "overlay";

      control-center-positionX = "right";
      control-center-positionY = "top";
      control-center-layer = "top";
      control-center-width = 360;
      control-center-height = -1;
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-margin-left = 0;

      notification-window-width = 360;
      timeout = 8;
      timeout-low = 4;
      timeout-critical = 0;

      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      keyboard-shortcuts = true;
      notification-grouping = true;
      image-visibility = "when-available";
      notification-2fa-action = true;

      widgets = [
        "title"
        #"dnd"
        "mpris"
        "volume"
        "backlight"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };

        dnd = {
          text = "Do Not Disturb";
        };

        volume = {
          label = "󰕾";
          show-per-app = true;
          show-per-app-icon = true;
          show-per-app-label = false;
        };

        backlight = {
          label = "󰖨";
          device = "intel_backlight";
          min = 5;
        };
        mpris = {
          image-size = 96;
          image-radius = 8;
        };
      };
    };
  };

}
