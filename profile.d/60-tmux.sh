#! /bin/bash
#  vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=sh :
# Steen Hegelund
# Time-Stamp: 2025-Apr-02 22:53

pane_id_prefix="resurrect_"
nvim_pane_id_prefix="nvim term"

# Create history directory if it doesn't exist
HISTS_DIR=$HOME/.tmux/bash_history
mkdir -p "${HISTS_DIR}"

if [ -n "${TMUX_PANE}" ]; then

  # Check if we've already set this pane title
  pane_id=$(tmux display -pt "${TMUX_PANE:?}" "#{pane_title}")
  if [[ $pane_id != "$pane_id_prefix"* ]] && [[ $pane_id != "$nvim_pane_id_prefix"* ]]; then

    # if not, set it to a random ID
    random_id=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
    printf "\033]2;$pane_id_prefix$random_id\033\\"
    pane_id=$(tmux display -pt "${TMUX_PANE:?}" "#{pane_title}")
  fi

  # use the pane's random ID for the HISTFILE
  export HISTFILE="${HISTS_DIR}/bash_history_tmux_${pane_id}"
else
  export HISTFILE="${HISTS_DIR}/bash_history_no_tmux"
fi

# Stash the new history each time a command runs.
export PROMPT_COMMAND="history -a"

# Provide TAT (tmux attach) with tab-expansion of session names
tat() {
    local path_name="$(basename "$PWD" | tr . -)"
    local session_name=${1-$path_name}
    local sessions=( $(tmux list-sessions 2>/dev/null | cut -d ":" -f 1 | grep "^$session_name$") )

    if [ -z "$TMUX" ]; then
        # Not in TMUX already
        if [ ${#sessions[@]} -gt 0 ]; then
            # If there is already a session with the same name, attach to it.
            tmux attach-session -t "$session_name"
        else
            # If there is no existing session, create a new (detached) one.
            tmux new-session -d -s "$session_name"
            tmux attach-session -t "$session_name"
        fi
    else
        # Already in TMUX
        if [ ${#sessions[@]} -eq 0 ]; then
            # If there is no existing session, create a new (detached) one.
            (TMUX='' tmux new-session -Ad -s "$session_name")
        fi
        # Open the session
        tmux switch-client -t "$session_name"
    fi
}

_tat() {
    COMPREPLY=()
    local session="${COMP_WORDS[COMP_CWORD]}"

    local sessions=( $(compgen -W "$(tmux list-sessions 2>/dev/null | awk -F: '{ print $1 }')" -- "$session") )
    COMPREPLY=( ${sessions[@]} ${directories[@]} )
}

complete -F _tat tat

# Provide RTAT (remote ssh tmux attach) with tab-expansion of servers and session names
rtat() {
    local server_name="$1"
    local session_name="$2"
    local sessions=( $(ssh -t $server_name tmux list-sessions 2>/dev/null | cut -d ":" -f 1 | grep "^$session_name$") )

    if [ ${#sessions[@]} -gt 0 ]; then
        # If there is already a session with the same name, attach to it.
        ssh -t $server_name tmux attach-session -t "$session_name"
    else
        # If there is no existing session, create a new (detached) one.
        ssh tmux -t $server_name new-session -d -s "$session_name"
        ssh tmux -t $server_name attach-session -t "$session_name"
    fi
}

_rtat() {
    local cur="${COMP_WORDS[COMP_CWORD]}"

    case $COMP_CWORD in
        1)
            local words=( $(compgen -W "$(grep -i '^host' ~/.ssh/config)" -- "$cur" ) )
            COMPREPLY=( ${words[@]} )
            ;;
        2)
            local words=( $(compgen -W "$(ssh -t ${COMP_WORDS[COMP_CWORD-1]} tmux list-sessions 2>/dev/null | awk -F: '{ print $1 }')" -- "$cur" ) )
            COMPREPLY=( ${words[@]} )
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
}

complete -F _rtat rtat
