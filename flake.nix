{
  description = "Graeme's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zwift = {
      url = "github:netbrain/zwift";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    # Helper function to create a host configuration
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs hostname; };
      modules = [
        # Host-specific config (hardware, overrides)
        ./hosts/${hostname}

        # Shared modules
        ./modules/system/host-options.nix
        ./modules/system/common.nix
        ./modules/system/users.nix
        ./modules/system/packages.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.graeme = import ./modules/home/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
          ];
        }
      ];
    };
  in
  {
    nixosConfigurations = {
      thinkpad = mkHost "thinkpad";
      zenbook = mkHost "zenbook";
      donkey = mkHost "donkey";
    };
  };
}
