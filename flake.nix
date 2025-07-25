{
  description = "katsrc";
  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, flake-utils, nixpkgs, nur, ... }@inputs:
    let
      eachSystemOutputs = flake-utils.lib.eachDefaultSystem (system: rec {
        overlays.default = import ./overlay.nix;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nur.overlays.default
            overlays.default
          ];
        };
        devShells.default = import ./shell.nix { inherit pkgs; };
      });
      formatting = import ./formatting.nix {inherit inputs; };
    in eachSystemOutputs // rec {
      inherit (formatting) formatter;
    };
}

