{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    mkUser = username: {
      users.users.${username} = {
        home = "/home/${username}";
        isNormalUser = true;
        hashedPasswordFile = "./users/${username}.hash";
        extraGroups = ["podman"];
      };
      home-manager.users.${username} = import ./users/${username}.nix;
    };
    mkHost = hostname: {modules}:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        modules =
          [
            ./modules/configuration.nix
            ./modules/packages.nix
            ./modules/nix.nix

            home-manager.nixosModules.home-manager
            {
              networking.hostName = hostname;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs;};
              };
            }
          ]
          ++ modules;
      };
  in {
    nixosConfigurations = {
      Blizzard = mkHost "Blizzard" {
        modules = [
          ./hosts/Blizzard
          (mkUser "zilch")
        ];
      };
    };
  };
}
