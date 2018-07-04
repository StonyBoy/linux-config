export HISTCONTROL="ignoreboth"
export HISTFILESIZE="50000"

if [ "${TERM}" == "rxvt-unicode" ]; then
  #echo "Set LC_CTYPE to ${LC_CTYPE}"
  printf "\33]701;$LC_CTYPE\007"
fi

PROFILE_BASE=$(readlink -f $(dirname $(readlink -f ${BASH_SOURCE[0]}))/..)
if [ -e $PROFILE_BASE/scripts ]
then
    export PATH=$PATH:$PROFILE_BASE/scripts
fi

