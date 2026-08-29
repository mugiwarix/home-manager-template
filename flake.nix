{
  description = "A standalone Home Manager configuration template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:denful/import-tree";
  };

  outputs =
    inputs:
    let
      # Customize these values for the Home Manager profile.
      username = "your-username";
      homeDirectory = "/home/${username}";
      system = "x86_64-linux"; # Or "aarch64-linux".

      homeConfiguration = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs { inherit system; };
        modules = [
          (inputs.import-tree ./modules)
          {
            home.username = username;
            home.homeDirectory = homeDirectory;

            # This controls Home Manager compatibility and should not be changed casually.
            home.stateVersion = "26.05";

            programs.home-manager.enable = true;
          }
        ];
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      flake = {
        homeConfigurations.${username} = homeConfiguration;
        checks.${system}.home-configuration = homeConfiguration.activationPackage;
      };

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt-tree;
      };
    };
}
