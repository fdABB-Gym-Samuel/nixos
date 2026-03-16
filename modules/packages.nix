{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wget
    curl

    wl-clipboard

    neovim
  ];

  programs.hyprland.enable = true;

  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Samuel Olsson";
        email = "samuel.olsson@hitachigymnasiet.se";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
