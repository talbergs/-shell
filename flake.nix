{
  description = ''
    A fish configuration
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    editor.url = "github:talbergs/-editor";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        args@{ pkgs, system, ... }:
	let
	  nvim = inputs.editor.packages.${system}.default;
	in
        {
          packages.":comment" = pkgs.callPackage ./c_comment.nix args;
          packages.default = pkgs.callPackage ./default.nix { inherit nvim; };
        };
    };
}
