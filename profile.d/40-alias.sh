if [ "$(uname)" == "Darwin" ]; then
	alias ls="ls -G"
else
	alias ls="ls --color=tty"
fi
alias pst="ps -AfH f"
alias pstl="ps -fH f -u `id -u`"
alias lsofi="lsof -i -n -P"
alias sudo='sudo '
alias du_sorted='du -abx | sort -n | gawk '\''{if(match($0, /^([[:digit:]]+)[\t ]+(.+)/, a)){ s = int(a[1]); n = a[2]; u = "B "; if(s >= 1024){s = s/1024; u = "KB";} if(s >= 1024){s = s/1024; u = "MB";} if(s >= 1024){s = s/1024; u = "GB";} if(s >= 1024){s = s/1024; u = "TB";} printf("%8.2f%s %s\n", s, u, n)}}'\'''
alias fzfp='fzf --preview="bat --style=full --color=always {}" --multi --bind "enter:execute(nvim {})" --bind "space:execute(nvim -O {+})"'
alias gdrive='rclone --vfs-cache-mode writes mount "GoogleDrive": ~/GoogleDrive &'
