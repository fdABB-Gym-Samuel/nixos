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

    # A function rather than an alias: the package name has to be concatenated
    # onto `nixpkgs#` with no space, which alias expansion cannot do.
    initContent = ''
      nr() {
        if (( $# == 0 )); then
          print -u2 "usage: nr <package> [args...]"
          return 2
        fi
        local pkg=$1
        shift
        nix run "nixpkgs#$pkg" -- "$@"
      }
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
