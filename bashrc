if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
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

