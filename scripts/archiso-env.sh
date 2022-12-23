#!/bin/bash

ORIGINAL_PATH=$(pwd)

ARCH_LIVE=~/ArchLiveISO
mkdir -p -v $ARCH_LIVE

# ------------------------------------------------------------------------------
# Create baseline
# ------------------------------------------------------------------------------
BASELINE=$ARCH_LIVE/baseline
pacman -Syyu --noconfirm
pacman -S archiso --noconfirm
cp -r /usr/share/archiso/configs/baseline $ARCH_LIVE

# ------------------------------------------------------------------------------
# Git repositories
# ------------------------------------------------------------------------------
ROOT=$BASELINE/airootfs
mkdir -p -v $ROOT

HOME_ROOT=$ROOT/root
mkdir -p -v $HOME_ROOT

cd $HOME_ROOT
git clone git@github.com:mzotyo/Vimconfig.git
git clone git@github.com:mzotyo/Archdistro.git

# ------------------------------------------------------------------------------
# Packages to install
# ------------------------------------------------------------------------------
ARCHDISTRO=$HOME_ROOT/Archdistro
PACKAGES=$BASELINE/packages.x86_64
cat $ARCHDISTRO/packages.x86_64 >> $PACKAGES

# ------------------------------------------------------------------------------
# User rights: passwd, shadow, group, gshadow, sudoers
# ------------------------------------------------------------------------------
ETC=$ROOT/etc
mkdir -p -v $ETC

# file: /etc/passwd
echo 'root:x:0:0::/root:/bin/bash' > $ETC/passwd

# file: /etc/shadow
echo 'root:$6$Oj.cp2XlRP3ujoD1$o7Sg8b8sSmegMxTssGfkSYgpxhM4rXQedbyhzqir2cPsnnU3YaVrD1YAYhm3eFpWWgO.eivX3rAulk5dfzvu9.:19166::::::' > $ETC/shadow

# file: /etc/group
echo 'root:x:0:root' > $ETC/group
echo 'vboxsf:x:109:' >> $ETC/group

# file: /etc/gshadow
echo 'root:::root' > $ETC/gshadow

# file: /etc/sudoers
echo 'root ALL=(ALL:ALL) ALL' > $ETC/sudoers

# ------------------------------------------------------------------------------
# profile.sh
# ------------------------------------------------------------------------------
SHADOW="\[\"\/etc\/shadow\"\]=\"0:0:400\""
PASSWD="\[\"\/etc\/passwd\"\]=\"0:0:644\""
GROUP="\[\"\/etc\/group\"\]=\"0:0:644\""
GSHADOW="\[\"\/etc\/gshadow\"\]=\"0:0:600\""
ROOT_FOLDER="\[\"\/root\"\]=\"0:0:750\""
SUDOERS="\[\"\/etc\/sudoers\"\]=\"0:0:440\""
ID_RSA="\[\"\/root\/.ssh\/id_rsa\"\]=\"0:0:600\""
KNOWN_HOSTS="\[\"\/root\/.ssh\/known_hosts\"\]=\"0:0:600\""
ARCHISO_ENV="\[\"\/root\/Archdistro\/scripts\/archiso-env.sh\"\]=\"0:0:750\""
BUILD_ARCHISO="\[\"\/root\/Archdistro\/scripts\/build.sh\"\]=\"0:0:750\""
KEYRING_RESTORE="\[\"\/root\/Archdistro\/scripts\/keyring.sh\"\]=\"0:0:750\""
RESIZE_LIVE="\[\"\/root\/Archdistro\/scripts\/resize-live.sh\"\]=\"0:0:750\""

sed -i "s/  $SHADOW/\
\t$SHADOW\n\
\t$PASSWD\n\
\t$GROUP\n\
\t$GSHADOW\n\
\t$ROOT_FOLDER\n\
\t$SUDOERS\n\
\t$ARCHISO_ENV\n\
\t$ID_RSA\n\
\t$KNOWN_HOSTS\n\
\t$KEYRING_RESTORE\n\
\t$RESIZE_LIVE\n\
\t$BUILD_ARCHISO\
/" $BASELINE/profiledef.sh

# ------------------------------------------------------------------------------
# Other config files
# ------------------------------------------------------------------------------
cp ~/.ssh $HOME_ROOT -r

mv $HOME_ROOT/Vimconfig $HOME_ROOT/.vim
cp $HOME_ROOT/.vim/.vimrc $HOME_ROOT

mkdir -p -v $ETC/pacman.d
reflector --age 3 --protocol https --save $ETC/pacman.d/mirrorlist

cp $ARCHDISTRO/etc/locale.conf $ETC
cp $ARCHDISTRO/etc/locale.gen $ETC
cp $ARCHDISTRO/etc/vconsole.conf $ETC

cp $ARCHDISTRO/home/.config $HOME_ROOT -r
cp $ARCHDISTRO/home/.bashrc $HOME_ROOT
cp $ARCHDISTRO/home/.profile $HOME_ROOT
cp $ARCHDISTRO/home/.gitconfig $HOME_ROOT
cp $ARCHDISTRO/home/.xinitrc $HOME_ROOT

# ------------------------------------------------------------------------------
# Build ISO
# ------------------------------------------------------------------------------
mkdir -p -v $ARCH_LIVE/{out,work}
ln -s ~/Archdistro/scripts/archiso-env.sh $HOME_ROOT/archiso-env.sh

BUILD_SCRIPT=$ARCHDISTRO/scripts/build.sh
$BUILD_SCRIPT

# ------------------------------------------------------------------------------
# Remove baseline
# ------------------------------------------------------------------------------
pacman -Rns archiso --noconfirm
cd $ORIGINAL_PATH
