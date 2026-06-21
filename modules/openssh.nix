{ inputs, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    ports = [
      22
    ];
    settings = {
      ChallengeResponseAuthentication = false;
      KbdInteractiveAuthentication = true;
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
    allowSFTP = true;
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSa5OO4f9jcq54eGrlkIR/Gphv8XElHO2YfC0g9RMhJ zilch@Blizzard"
  ];
}
