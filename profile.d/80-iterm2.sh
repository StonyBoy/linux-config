# Steen Hegelund
# Time-Stamp: 2020-Mar-11 22:51
# Set information that can be used in an iTerm2 Badge
# 
function iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
}

