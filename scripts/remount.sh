#!/bin/bash

if [[ "$1" =~  [0-9]+[KMG] ]]; then
    mount -o remount,size=$1 /run/archiso/cowspace;
else
    mount -o remount,size=4G /run/archiso/cowspace;
fi
