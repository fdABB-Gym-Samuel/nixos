{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    nvim = {
      url = "github:fdABB-Gym-Samuel/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    depot = {
      url = "git+ssh://forgejo@git.cenitly.com:18088/cenitly/depot";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      deploy-rs,
      home-manager,
      treefmt-nix,
      nvim,
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
          hashedPasswordFile = "/home/${username}/.config/nixos/users/${username}.hash";
          extraGroups = [
            "podman"
            "wheel"
            "networkmanager"
          ];
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
            ./modules/networking.nix
            ./modules/fhs.nix
            ./modules/openssh.nix
            ./modules/fonts.nix

            home-manager.nixosModules.home-manager
            {
              networking.hostName = hostname;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                backupFileExtension = "bak_";
              };
            }
          ]
          ++ modules;
        };
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system} = {
        formatting = treefmtEval.config.build.check self;
      }
      // deploy-rs.lib.${system}.deployChecks self.deploy;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          deploy-rs.packages.${system}.deploy-rs
        ];
      };

      deploy = {
        nodes = {
          Blizzard = {
            hostname = "100.71.95.51";
            magicRollback = false;
            profiles.system = {
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.Blizzard;
              sshUser = "root";
              tempPath = "/tmp";
              user = "root";
            };
          };
          NixPix = {
            hostname = "100.114.164.17";
            magicRollback = false;
            profiles.system = {
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.NixPix;
              sshUser = "root";
              tempPath = "/tmp";
              user = "root";
            };
          };

        };
      };

      nixosConfigurations = {
        Blizzard = mkHost "Blizzard" {
          modules = [
            ./hosts/Blizzard
            (mkUser "zilch" pkgs.zsh)
          ];
        };
        NixPix = mkHost "NixPix" {
          modules = [
            ./hosts/NixPix
            (mkUser "regnm0ln1" pkgs.zsh)
          ];
        };
      };
    };
}
