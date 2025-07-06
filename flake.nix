{
  description = "dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
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
        "linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./.config/home-manager/my.nix ];
        };
      };
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs;
          user =
            let
              sudoUser = builtins.getEnv "SUDO_USER";
              currentUser = builtins.getEnv "USER";
            in
            if sudoUser != "" then sudoUser else currentUser;
        };
        modules = [
          {
            system.primaryUser = builtins.getEnv "USER";
          }
          ./.config/nix-darwin/configuration.nix
        ];
      };
    };
}
