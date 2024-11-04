{
  debug ? false,
  pkgs,
  #
  makeWrapper,
  makeBinaryWrapper,
  writeText,
  writeTextDir,
  lib,
  fish,
  symlinkJoin,
  #
  fzf,
  starship,
  groff,
  bat,
  fishPlugins,
  any-nix-shell,
  callPackage,

  go-md2man,
  man-db,
  wget,
  nvim,
}:
let
  myWrapper = if debug then makeWrapper else makeBinaryWrapper;

  initPlugin = plugin: ''
    begin
      set -l __plugin_dir ${plugin}/share/fish

      if test -d $__plugin_dir/vendor_functions.d
        set -p fish_function_path $__plugin_dir/vendor_functions.d
      end

      if test -d $__plugin_dir/vendor_completions.d
        set -p fish_complete_path $__plugin_dir/vendor_completions.d
      end

      if test -d $__plugin_dir/vendor_conf.d
        for f in $__plugin_dir/vendor_conf.d/*.fish
          source $f
        end
      end
    end
  '';

  plugins = with fishPlugins; [
    foreign-env
    colored-man-pages
    fzf
    bass
    z
  ];

  fish_user_config = writeText "user_config.fish" ''
    # Only source once
    # set -q __fish_config_sourced; and exit
    # set -gx __fish_config_sourced 1

    ${lib.fileContents ./environment.fish}

    ${lib.concatMapStringsSep "\n" initPlugin plugins}

    if status is-login
    end

    if status is-interactive
      ${lib.fileContents ./interactive.fish}
      ${lib.fileContents ./all.fish}
      set -gx STARSHIP_CONFIG ${./starship.toml}
      function starship_transient_prompt_func
        starship module character
      end
      ${starship}/bin/starship init fish | source
      enable_transience
    end

    zellij
    # zellij --layout.nix
  '';

  fish' = fish.overrideAttrs (old: {
    # patches = [
    #   ./fish-on-tmpfs.patch
    # ];
    # doCheck = false;
    postInstall =
      old.postInstall
      # echo "$(<${fish_user_config})" >> $out/etc/fish/config.fish
      + ''
        echo "source ${fish_user_config}" >> $out/etc/fish/config.fish
      '';
  });

  extraPackages = (import ./packages.nix { inherit pkgs; }) ++ [
    (import ./c_comment.nix { inherit pkgs lib; })
    (import ./git.nix { inherit pkgs; })
    nvim
    go-md2man
    man-db
    wget
    fzf
    starship
    any-nix-shell
    groff
    (symlinkJoin {
      inherit (bat) name pname version;
      paths = [ bat ];
      buildInputs = [ myWrapper ];
      postBuild = ''
        wrapProgram $out/bin/bat \
          --add-flags '--theme=ansi' \
          --add-flags '--style=changes,header' \
          --add-flags '--plain' \
          --add-flags '--paging=auto'
      '';
    })
  ];
in
symlinkJoin {
  name = with fish'; "${pname}-${version}";
  inherit (fish') pname version;
  paths = [ fish' ] ++ extraPackages;
  nativeBuildInputs = [ myWrapper ];
  __nocachix = debug;
  postBuild = ''
    wrapProgram $out/bin/fish \
      --set MANPAGER 'sh -c "col -bx | bat --paging=always -l man -p"' \
      --prefix PATH ':' $out/bin \
  '';
}
