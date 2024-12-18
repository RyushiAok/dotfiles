# https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/flake.nix

{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Home manager 
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      homeConfigurations = {
        "my@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./.config/home-manager/my.nix ];
        };
        "my@mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./.config/home-manager/my.nix ];
        };
        "minimal@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./.config/home-manager/minimal.nix ];
        };
        "minimal@mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; }; 
          modules = [ ./.config/home-manager/minimal.nix ];
        };
      };
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            users.users.${builtins.getEnv "USER"}.home = builtins.getEnv "HOME";
            home-manager.users.${builtins.getEnv "USER"} = import ./.config/home-manager/my.nix;
          }
          ./.config/nix-darwin/configuration.nix
        ];
      };
    };
}
