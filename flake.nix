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
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, ... }:
    let
      utils-out = flake-utils.lib.simpleFlake {
          inherit self nixpkgs;
            name = "katsrc";
            overlay = ./overlay.nix;
            shell = ./shell.nix;
        };
    in utils-out;
}

