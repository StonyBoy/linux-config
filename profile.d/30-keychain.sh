# Keychain
KEYCHAIN=0            
test -x "/usr/bin/keychain" && KEYCHAIN=1
if [ $KEYCHAIN -eq 1 ] && [ -e ${HOME}/.ssh/id_rsa ] ; then
  keychain -q id_rsa
  [ -z "${HOSTNAME}" ] && HOSTNAME=$(uname -n)
  [ -f ${HOME}/.keychain/${HOSTNAME}-sh ] && \
      . ${HOME}/.keychain/${HOSTNAME}-sh
  [ -f ${HOME}/.keychain/${HOSTNAME}-sh-gpg ] && \
    . ${HOME}/.keychain/${HOSTNAME}-sh-gpg
fi
