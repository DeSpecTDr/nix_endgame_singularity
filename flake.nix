{
  description = "Flake for Endgame Singularity";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      apps = rec {
        default = singularity;
        singularity = {
          type = "app";
          program = "${self.packages.${system}.singularity}/bin/singularity";
        };
      };
      packages = rec {
        default = singularity;
        singularity = with pkgs; ((endgame-singularity.overrideAttrs (oldAttrs: {
            propagatedBuildInputs = with python38.pkgs; [(callPackage ./pygame.nix {}) numpy polib];
          }))
          .override {
            python3 = python38;
          });
      };
    });
}
