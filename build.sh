#!/bin/bash

ARCH_LIVE=~/ArchLiveISO

rm -r $ARCH_LIVE/work
rm -r $ARCH_LIVE/out

pacman -Scc --noconfirm
cd $ARCH_LIVE
mkarchiso -v -w work -o out baseline
