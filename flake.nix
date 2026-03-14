{
  description = "NixOS configuration with flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fsel = {
      url = "github:Mjoyufull/fsel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      flake = {
        nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs self; };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./hosts/nixos
            inputs.nur.modules.nixos.default
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";
                users.roach = import ./users/roach;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
        };
      };
    };
}
