#!/usr/bin/env bash
NIXPKGS_ALLOW_UNFREE=1 nix run github:talbergs/-shell --extra-experimental-features "flakes nix-command" --impure
