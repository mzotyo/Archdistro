# Create aliases for custom shorthand commands
alias la="ls -hal"
alias remount="/root/Archdistro/scripts/remount.sh"
alias keyring="/root/Archdistro/scripts/keyring.sh"
alias sysupdate="pacman -Syyu --noconfirm"

# Configure bash prompt colors
export PS1="\e[0;31m\u\e[0m\e[1;32m@\e[0m\e[0;32m\h\e[0m \e[1;34m\W\e[0m \e[1;30m\$\e[0m "

# Generate the locales configured in the /etc/locale.gen
locale-gen 1> /dev/null 2> /dev/null

# Allocate 4G o memory for the live arch linux
remount 4G

# Update arch linux keyrings
keyring

# Update linux system
sysupdate
