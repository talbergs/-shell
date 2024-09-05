{
  description = ''
    A fish configuration
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
        { pkgs, ... }:
        let
          inherit (pkgs) lib;
          name = "fish";
          exe = lib.getExe pkgs.fish;
          runtime = lib.strings.escapeShellArg ''
            source ${./all.fish}
          '';
          init = "${exe} --init-command ${runtime}";
          text = ''${init}'';
        in
        {
          packages.default = pkgs.writeShellApplication {
            inherit text;
            inherit name;
            runtimeInputs = with pkgs; [
              fishPlugins.fzf-fish
              nh
            ];
          };
        };
    };
}
