{
  description = "Home Manager configuration of razobeckett";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    userSettings = {
      username = "razobeckett";
    };

    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.${userSettings.username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home.nix];
    };
  };
}
