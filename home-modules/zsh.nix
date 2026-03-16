{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      icat = "kitten icat $@";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
