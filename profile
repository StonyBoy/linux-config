# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

#export TZ='America/New_York'
export TZ='Europe/Copenhagen'

[ -d $HOME/.rvm/bin ] && pathappend ~/.rvm/bin
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[ -d ~/.cargo/bin ] && source "$HOME/.cargo/env"
