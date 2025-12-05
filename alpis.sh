#!/bin/bash

# Alpine Linux Post-Installation Script

# config
mirror_branch="v3.23"
locale="ru_RU.UTF-8"

# user and password settings
read -p "Username: " username
read -sp "$username password: " user_password
echo

# mirror
{
  echo "https://mirror.yandex.ru/mirrors/alpine/$mirror_branch/main"
  echo "https://mirror.yandex.ru/mirrors/alpine/$mirror_branch/community"
} > /etc/apk/repositories
apk update

# setup xorg
setup-xorg-base

# install packages
wget zurg3.github.io/alpine-linux-info/pkg.txt
# apk add $(xargs -a pkg.txt)
apk add $(cat pkg.txt)

# setup user
useradd -m -g users -G wheel -s /bin/bash $username
(
  echo "$user_password";
  echo "$user_password";
) | passwd $username
echo -e "\n%wheel ALL=(ALL) ALL" >> /etc/sudoers

# setup locale
{
  echo "LANG=$locale"
  echo "LC_ALL=$locale"
} > /etc/profile.d/00locale.sh

# setup cyrillic font for console
echo 'consolefont="cyr-sun16.psfu.gz"' > /etc/conf.d/consolefont

# autostart services
rc-update add dbus
rc-update add lxdm
rc-update add consolefont boot

reboot
