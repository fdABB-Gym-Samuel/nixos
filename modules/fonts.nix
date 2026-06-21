{ config, pkgs, ... }:

{

  fonts.packages = with pkgs; [
    inter
    libertinus
    nerd-fonts.iosevka
    nerd-fonts.fira-code
    nerd-fonts.noto
    nerd-fonts.roboto-mono
    noto-fonts-color-emoji
    roboto
    source-serif-pro
    (google-fonts.override {
      fonts = [
        "Arimo"
        "DM Sans"
        "Domine"
        "Familjen Grotesk"
        "Inria Serif"
        "Instrument Sans"
        "Instrument Serif"

        "Michroma"
        "Onest"
        "Source Serif 4"
        "Special Gothic Expanded One"
      ];
    })
  ];

}
