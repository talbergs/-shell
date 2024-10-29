{ pkgs, ... }:
pkgs.symlinkJoin {
  name = "_";
  paths = with pkgs; [ git git-extras delta ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/git --set GIT_CONFIG_GLOBAL ${./gitconfig}";
}
