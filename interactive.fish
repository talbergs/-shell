# Passphrase once.
# eval (SHELL=fish keychain --eval --agents ssh $HOME/.ssh/id_ed25519)

# if test -z (pgrep ssh-agent | string collect)
#     eval (ssh-agent -c)
#     set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
#     set -Ux SSH_AGENT_PID $SSH_AGENT_PID
# end

# function __ssh_agent_start -d "start a new ssh agent"
#     ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
#     chmod 600 $SSH_ENV
#     source $SSH_ENV > /dev/null
# end

# function __ssh_agent_is_started -d "check if ssh agent is already started"
#     if test -n "$SSH_CONNECTION"
#         # This is an SSH session
#         ssh-add -l > /dev/null 2>&1
#         if test $status -eq 0 -o $status -eq 1
#             # An SSH agent was forwarded
#             return 0
#         end
#     end

#     if begin; test -f "$SSH_ENV"; and test -z "$SSH_AGENT_PID"; end
#         source $SSH_ENV > /dev/null
#     end

#     if test -z "$SSH_AGENT_PID"
#         return 1
#     end

#     ssh-add -l > /dev/null 2>&1
#     if test $status -eq 2
#         return 1
#     end
# end

# if test -z "$SSH_ENV"
#     set -xg SSH_ENV $HOME/.ssh/environment
# end

# if not __ssh_agent_is_started
#     __ssh_agent_start
# end
