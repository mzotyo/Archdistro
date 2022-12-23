#!/bin/bash

pacman-key --init                           1> /dev/null 2> /dev/null
pacman-key --populate                       1> /dev/null 2> /dev/null
#pacman-key --refresh-keys                   1> /dev/null 2> /dev/null
#pacman -Syyu --noconfirm                    1> /dev/null 2> /dev/null
#pacman -S archlinux-keyring --noconfirm     1> /dev/null 2> /dev/null
