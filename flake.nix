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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    nixvim,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    mkHome = username:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          stylix.homeManagerModules.stylix
          nixvim.homeManagerModules.nixvim
          ./homemanager/home.nix
          {
            username = username;
          }
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        # extraSpecialArgs = {};
      };
  in {
    nixosConfigurations.y4080 = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        home-manager = home-manager;
      };
      modules = [
        stylix.nixosModules.stylix
        ./nixos/configuration.nix
      ];
    };

    homeConfigurations."emilen" = mkHome "emilen";
    homeConfigurations."enadeau" = mkHome "enadeau";

    packages.${system}.nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = import ./nixvim;
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
