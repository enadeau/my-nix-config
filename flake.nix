{
  description = "Home Manager configuration of emilen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."emilen" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        stylix.homeManagerModules.stylix
        ./home.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "home manager";
      buildInputs = [
        pkgs.alejandra
        pkgs.pre-commit
      ];

      shellHook = ''
        pre-commit install > /dev/null
      '';
    };
  };
}
