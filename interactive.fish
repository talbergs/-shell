# set -gx fish_color_normal brwhite
# set -gx fish_color_command green
# set -gx fish_color_keyword brblue
# set -gx fish_color_quote yellow
# set -gx fish_color_redirection brwhite
# set -gx fish_color_end brred
# set -gx fish_color_error -o red
# set -gx fish_color_param white
# set -gx fish_color_comment brblack
# set -gx fish_color_selection --background=brblack
# # set -gx fish_color_selection cyan
# # set -gx fish_color_search_match cyan
# set -gx fish_color_search_match --background=brblack
# set -gx fish_color_operator green
# set -gx fish_color_escape brblue
# set -gx fish_color_autosuggestion brblack
# set -gx fish_pager_color_progress brblack
# set -gx fish_pager_color_prefix green
# set -gx fish_pager_color_completion white
# set -gx fish_pager_color_description brblack

# Print newline after a command
function postexec_test --on-event fish_postexec
    echo
end
