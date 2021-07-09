export HISTCONTROL="ignoreboth"
export HISTFILESIZE="50000"

if [ "${TERM}" == "rxvt-unicode" ]; then
  #echo "Set LC_CTYPE to ${LC_CTYPE}"
  printf "\33]701;$LC_CTYPE\007"
fi

if [ "$(uname)" == "Darwin" ]; then
	PROFILE_BASE=$(readlink $(dirname $(readlink ${BASH_SOURCE[0]}))/..)
else
	PROFILE_BASE=$(readlink -f $(dirname $(readlink -f ${BASH_SOURCE[0]}))/..)
fi
[ -d $PROFILE_BASE/scripts ] && pathappend $PROFILE_BASE/scripts

