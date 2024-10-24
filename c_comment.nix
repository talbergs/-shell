{ pkgs, lib, ... }:
pkgs.writeScriptBin ":comment" ''
  SYS_CLIPBOARD=clip.exe
  JIRAUSER=mtalbergs
  BITBUCKET_PROJECT=https://git.zabbix.com/projects/ZBX/repos/zabbix

  fzclip() {
      local -n clips=$1
      local IFS=$'\n'
      echo "${
        lib.strings.concatStrings [
          # escaping "$" in nix string
          "$"
          "{clips[*]}"
        ]
      }" | ${pkgs.fzf}/bin/fzf | $SYS_CLIPBOARD
  }
  SHA="$(git rev-parse HEAD | head -c 11)"

  SHALINK="[$SHA|$BITBUCKET_PROJECT/commits/$SHA]"

  CLIPS=("<[~$JIRAUSER]> CLOSED")
  CLIPS+=("<[~$JIRAUSER]> WON'T FIX")
  CLIPS+=("*(1)* No translation string changes.")

  CLIPS+=("<[~$JIRAUSER]> CLOSED with minor fix in $SHALINK")
  CLIPS+=("<[~$JIRAUSER]> RESOLVED in $SHALINK")
  CLIPS+=("<[~$JIRAUSER]> IMPLEMENTED in $SHALINK")
  CLIPS+=("$SHALINK")

  CLIPS+=("git cherry-pick -m 1 -x $SHA")
  CLIPS+=("git merge origin/$REF --no-ff --no-commit")
  CLIPS+=("Code review successful.")

  fzclip CLIPS
''
