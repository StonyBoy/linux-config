#! /bin/bash
#  vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=sh :
# Steen Hegelund
# Time-Stamp: 2024-Dec-04 15:52

# Provide builder.py
builder() {
    ~/work/scripts/builder.py $*
}

_builder() {
    COMPREPLY=()
    local session="${COMP_WORDS[COMP_CWORD]}"

    local sessions=( $(compgen -W "$(~/work/scripts/builder.py --socs)" -- "$session") )
    COMPREPLY=( ${sessions[@]} )
}

complete -F _builder builder
