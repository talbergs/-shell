{
  description = ''
    A fish configuration
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  # outputs2 = args@{ self, flake-parts, ... }:
  #   let
  #     buildAttrs = { bin }: {
  #       systems =
  #         [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  #       perSystem = { pkgs, system, ... }: bin { inherit pkgs; };
  #     };
  #     bin = { pkgs, ... }:
  #       pkgs.writeShellApplication {
  #         name = "shell";
  #         runtimeInputs =
  #           [ pkgs.fish pkgs.fishPlugins.fzf-fish pkgs.nh pkgs.nix-your-shell ];
  #       };
  #   in flake-parts.lib.mkFlake { inputs = args; } (buildAttrs { inherit bin; });

  # 10:50
  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        # with pkgs;
        # with pkgs.lib;
        let
          inherit (pkgs) lib fish nix-your-shell;
          name = "fish";
          nys = lib.getExe nix-your-shell;
          exe = lib.getExe fish;
          selfbin = "~/Nix/Shell/result/bin/${name}";
          # Find a way to find drv pre-build store path. Now ~/Nix/* hardcoaded.
          config = {
            tail = pkgs.writeText "tail.fish" (pkgs.lib.readFile ./all.fish);
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
            source ${config.nix-shell}
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

# outputs = { self, flake-parts, ... }@inputs:

#   {
#     packages.default = drv;
#   }

#   flake-parts.lib.mkFlake { inherit inputs; } {
#     systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
#     perSystem = { pkgs, system, ... }: let a = 4; b = 4; drv = pkgs.writeShellApplication {

#           name = "fish";
#           runtimeInputs = [
#             pkgs.fish
#             pkgs.fishPlugins.fzf-fish
#             pkgs.nh
#             pkgs.nix-your-shell
#           ];

#           # aext = let c = 2; in { o = c; };

#           text = let
#             selfbin = "~/Nix/Shell/bin/fish"; # find a way to find own store path.
#             exe = pkgs.lib.getExe pkgs.nix-your-shell;
#             nix-shell = pkgs.writeTextFile {
#               name = "nix-shell.fish";
#               text = ''
#                 function nix-shell --description "Start an interactive shell based on a Nix expression"
#                     ${exe} ${selfbin} nix-shell -- $argv
#                 end
#                 function nix --description "Reproducible and declarative configuration management"
#                     ${exe} ${selfbin} nix -- $argv
#                 end
#               '';
#             };
#             initcmd = ''
#               set -g fish_autosuggestion_enabled 1
#               source ${nix-shell}
#               source /home/done/Nix/Shell/all.fish
#               ~/Nix/Editor/result/nvim +term +normal a
#             '';
#           in ''
#             fish --init-command "${initcmd}"
#           '';
#       in {
#         };
# }

