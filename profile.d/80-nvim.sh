# Support neovim as the default editor
alias vi=nvim
alias vim=nvim
alias vimdiff='nvim -d'
export EDITOR=nvim
export SYSTEMD_EDITOR=nvim
NEOPROFILEHOME=$HOME/.config/nvim-profiles

function createneoprofile()
{
    if [[ "${NVIM_PROFILE_NAME}" == "" ]]; then
        export NVIM_PROFILE_NAME=full
    fi
    if [[ ! -e ${NEOPROFILEHOME}/${NVIM_PROFILE_NAME} ]]; then
        mkdir -p ${NEOPROFILEHOME}/${NVIM_PROFILE_NAME}/{config,data,cache}
    fi
}

function neoprofile()
{
    if [[ $# -gt 0 ]]; then
        export NVIM_PROFILE_NAME=$1
    else
        echo Profile: $NVIM_PROFILE_NAME
    fi
    createneoprofile
}

function neovim()
{
    createneoprofile
    XDG_CONFIG_HOME="${NEOPROFILEHOME}/${NVIM_PROFILE_NAME}/config" \
        XDG_DATA_HOME="${NEOPROFILEHOME}/${NVIM_PROFILE_NAME}/data" \
        XDG_CACHE_HOME="${NEOPROFILEHOME}/${NVIM_PROFILE_NAME}/cache" \
        nvim "$@"
}
