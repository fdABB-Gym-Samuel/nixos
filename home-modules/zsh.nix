{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      icat = "kitten icat $@";
      cld = "CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1 claude --dangerously-skip-permissions";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
