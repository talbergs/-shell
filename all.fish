bind \cz 'fg' # <c-k> to toggle-nvim workflow (dropshell)
export NIX_ALLOW_UNFREE=1

function pwd:set
  set -Ux LAST_PWD $PWD
  export LAST_PWD=$PWD
end

function pwd:get
 cd $LAST_PWD
end

function fish_greeting
    pwd:get
end

function fish_prompt:user_char
  if fish_is_root_user
      # echo -n "♯ "
      echo -n "⋕ "
  else
      echo -n "⊱⋅"
  end
end

function fish_prompt:jobs
  # Check if there are any background jobs
  set jobs_list (jobs)

  # If there are jobs, print them
  if test -n "$jobs_list"
    for job in $jobs_list
        echo " > $job"
    end
  end
end

function fish_prompt
  pwd:set
  tput setaf 1
  fish_prompt:jobs
  tput setaf 3
  echo \(shell depth: $SHLVL\)\(MOPIDY-DAYZ\)
  tput sgr0
  tput setaf 6
  echo $PWD
  tput bold
  tput setaf 9
  fish_prompt:user_char
  tput sgr0
end

function l
    ls -lAh --full-time -s -tr $argv # -[t]imesort[r]everse
end

abbr -a -g +x chmod +x

abbr -a -g g git
abbr -a -g gst git status
abbr -a -g ga git add
abbr -a -g gc git commit
abbr -a -g gp git push
abbr -a -g gb git branch
abbr -a -g gd git diff
abbr -a -g gr git remote
abbr -a -g gco git checkout
abbr -a -g glog git log --format=fuller --first-parent --abbrev-commit

abbr -a -g nb nom build

abbr -a -g rmf rm -rf
abbr -a -g v nvim
