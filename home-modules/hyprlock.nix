{
  config,
  pkgs,
  ...
}: {
  programs.hyprlock.enable = true;

  programs.hyprlock.settings = {
    input-field = {
      monitor = "";
      size = "10%, 3%";
      outline_thickness = 3;
      inner_color = "rgba(1e1e2eee) # no fill";
      outer_color = "rgba(cdd6f4ee) rgba(1e1e2eee) 45deg";
      check_color = "rgba(00ff9900) rgba(ff663300) 120deg";
      fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";
      fade_on_empty = "false";
      font_color = "rgb(CDD6F4)";
      rounding = "full";
      position = "0, -100";
      halign = "center";
      valign = "center";
    };
    label = [
      {
        monitor = "";
        size = "40% 60%";
        text = "$TIME";
        color = "rgb(CDD6F4)";
        font_size = 96;
        font_family = "monospace";
        position = "0, 300";
      }
      {
        monitor = "";
        size = "20% 10%";
        text = "Log in as $USER:";
        font_size = 18;
        position = "0, -30";
        color = "rgb(CDD6F4)";
      }
    ];
    background = {
      monitor = "";
      path = "screenshot";
      blur_passes = 4;
      blur_size = 2;
    };
  };
}
