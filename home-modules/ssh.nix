{ inputs, config, ... }:

{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "git.cenitly.com" = {
        hostname = "git.cenitly.com";
        port = 18088;
        user = "forgejo";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };
}
