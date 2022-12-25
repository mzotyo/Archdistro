# Create aliases for custom shorthand commands
alias remount=/root/Archdistro/scripts/remount.sh

export PS1="\e[0;31m\u\e[0m\e[1;32m@\e[0m\e[0;32m\h\e[0m \e[1;34m\W\e[0m \e[1;30m\$\e[0m "
locale-gen 1> /dev/null 2> /dev/null

# Allocate 4G o memory for the live arch linux
remount 4G
/root/Archdistro/scripts/keyring.sh
