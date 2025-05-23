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
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = [
      (import ./overlays/aws-export-credentials.nix)
    ];
    pkgs = import nixpkgs {
      inherit system;
      overlays = overlays;
    };
  in {
    nixosConfigurations.y4080 = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        home-manager = home-manager;
      };
      modules = [
        inputs.stylix.nixosModules.stylix
        ./hosts/y4080/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.emilen = import ./homeManagerModules;
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    };

    homeConfigurations = {
      "enadeau@emile-ruv" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          inputs.stylix.homeModules.stylix
          ./hosts/work/home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };

    packages.${system}.nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
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
