if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -x /usr/local/bin/brew ]; then
  # If brew exists
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


[ -d $HOME/.rvm/bin ] && pathappend ~/.rvm/bin
[ -d $HOME/.rvm/gems/ruby-2.6.3/bin ] && pathappend ~/.rvm/gems/ruby-2.6.3/bin

# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

[ -d ~/.cargo/bin ] && source "$HOME/.cargo/env"


