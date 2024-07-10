{
  description = ''
    A fish configuration
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) lib fish nix-your-shell;
          name = "fish";
          nys = lib.getExe nix-your-shell;
          exe = lib.getExe fish;
          selfbin = "~/Nix/Shell/result/bin/${name}";
          # Find a way to find drv pre-build store path. Now ~/Nix/* hardcoaded.
          config = {
            tail = pkgs.writeText "tail.fish" (lib.readFile ./all.fish);
            nix-shell = pkgs.writeTextFile {
              name = "nix-shell.fish";
              text = ''
                function nix-shell --description "Start an interactive shell based on a Nix expression"
                    ${nys} ${selfbin} nix-shell -- $argv
                end
                function nix --description "Reproducible and declarative configuration management"
                    ${nys} ${selfbin} nix -- $argv
                end
              '';
            };
          };
          runtime = lib.strings.escapeShellArg ''
            source ${config.tail}
            # source ${config.nix-shell}
          '';
          init = "${exe} --init-command ${runtime}";
        in {

          packages.default = pkgs.writeShellApplication {
            # inherit text;
            text = init;
            inherit name;
            runtimeInputs = with pkgs; [
              fish
              fishPlugins.fzf-fish
              nh
              nix-your-shell
            ];
          };
        };
    };
}
