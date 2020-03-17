if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

# If brew exists
if [ -x /usr/local/bin/brew ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
  fi
  for COMFILE in ${HOME}/.local/share/bash-completion/completions/*; do
      if [ -f ${COMFILE} ]; then
          . ${COMFILE}
      fi
  done
fi

HAVE_TTY=1
# SSH connection without a tty (scp, sftp)
test -n "$SSH_CONNECTION" -a -z "$SSH_TTY" && HAVA_TTY=0
test -n "$MC_SID" && HAVA_TTY=0

if [ $HAVE_TTY -eq 1 ]; then
  echo
  echo -e "Welcome to $(uname -n)."
  echo

  for SHFILE in ${HOME}/.profile.d/*.sh; do
      if [ -f ${SHFILE} ]; then
          echo "Running: ${SHFILE}"
          . ${SHFILE}
      fi
  done
fi

echo ""


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
