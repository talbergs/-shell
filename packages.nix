{ pkgs, ... }:
with pkgs;
[
  tailspin
  odin
  skim
  keychain # https://www.funtoo.org/Funtoo:Keychain
  zellij
  less
  pv
  just # < A scripting dashboard
  gnupg
  entr
  cntr
  tldr
  dig
  nix-output-monitor
  mariadb
  translate-shell
  nixfmt-rfc-style
  alejandra # an uncomprimising nix formatter
  zip
  pciutils
  busybox
  awscli2
  lua-language-server
  grc # needed for fish plugin
  fd
  xdg-utils
  cliphist
  nh
  # just run
  # nix-shell -p 'python3.withPackages(ps: with ps; [ pytorch jupyterlab ])' --run jupyter-lab
  pyright
  ffmpeg
  python3
  python3Packages.pip
  python3Packages.numpy
  # python3Packages.pytorch
  # python3Packages.virtualenv
  # python3Packages.tensorboard
  # python3Packages.matplotlib
  # python3Packages.torchvision
  # python3Packages.jupyterlab
  # python3Packages.ipython
  # python3Packages.python-lsp-server
  nerd-fonts.terminess-ttf
  go
  gopls
  brightnessctl
  tree-sitter
  terraform-ls
  # nodePackages.intelephense
  fzf
  nodejs
  zig
  avizo
  php
  php84Packages.psysh
  php84Packages.composer
  lua
  fuzzel
  libnotify
  # fish
  mpv
  foot
  jq
  yq
  jqp
  htop
  bat
  ollama # ollama run orca-mini
  keepassxc
  keepmenu
  ripgrep
  sysz
  tree
]
