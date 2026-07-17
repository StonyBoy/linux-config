#! /bin/bash
# -*-sh-*-

# fzf picker: pushd to a Claude session folder and resume it
__claude_session_widget() {
    local out cwd sid
    out=$(claude_sessions.py --emit) || return
    [ -n "$out" ] || return
    cwd=${out%%$'\t'*}
    sid=${out##*$'\t'}
    if [ -n "$cwd" ] && [ -d "$cwd" ]; then
        pushd "$cwd" >/dev/null || return
    fi
    claude --resume "$sid"
}

# Ctrl-x s : browse Claude sessions with fzf (change the key here)
if [[ $- == *i* ]]; then
    bind -x '"\C-xs": __claude_session_widget' 2>/dev/null
fi
