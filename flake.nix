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
      devShell = with pkgs;
        mkShell {
          nativeBuildInputs = [
            ((endgame-singularity.overrideAttrs (oldAttrs: {
              propagatedBuildInputs = with python38.pkgs; [(callPackage ./pygame.nix {}) numpy polib];
            })).override {
              python3 = python38;
            })
          ];
        };
    });
}
