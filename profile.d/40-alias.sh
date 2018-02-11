alias du_sorted="du -abx | sort -n | gawk '{if(match(\$0, /^([[:digit:]]+)[\\t ]+(.+)/, a)){ s = int(a[1]); n = a[2]; u = \"B \"; if(s >= 1024){s = s/1024; u = \"KB\";} if(s >= 1024){s = s/1024; u = \"MB\";} if(s >= 1024){s = s/1024; u = \"GB\";} if(s >= 1024){s = s/1024; u = \"TB\";} printf(\"%8.2f%s %s\\n\", s, u, n)}}'"

alias ls="ls --color=tty"
alias pst="ps -AfH f"
alias pstl="ps -fH f -u `id -u`"
alias lsofi="lsof -i -n -P"

alias openocd_serval="sudo openocd -f interface/ftdi/flyswatter2.cfg -f vtss/serval1-ref.cfg"

