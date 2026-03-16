{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      treefmt-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      mkUser = username: shell: {
        users.users.${username} = {
          home = "/home/${username}";
          isNormalUser = true;
          hashedPasswordFile = "./users/${username}.hash";
          extraGroups = [ "podman" ];
          shell = shell;
        };
        home-manager.users.${username} = import ./users/${username}.nix;
      };
      mkHost =
        hostname:
        { modules }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./modules/configuration.nix
            ./modules/packages.nix
            ./modules/nix.nix

            home-manager.nixosModules.home-manager
            {
              networking.hostName = hostname;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ]
          ++ modules;
        };
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks = {
        formatting.${system} = treefmtEval.config.build.check;
      };
      nixosConfigurations = {
        Blizzard = mkHost "Blizzard" {
          modules = [
            ./hosts/Blizzard
            (mkUser "zilch" pkgs.zsh)
          ];
        };
      };
    };
}
