#!/bin/bash

pacman -Scc --noconfirm

cd $1
mkdir -p -v work
mkarchiso -v -w work -o $2 baseline
