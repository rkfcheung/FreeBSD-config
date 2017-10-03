#!/usr/bin/env sh

THIS_DIR=$(cd $(dirname $0); pwd)
BSD_NAME=`uname`
if [ "$BSD_NAME" == "FreeBSD" ]; then
  echo "Checking FreeBSD Updates..."
	freebsd-update fetch install
fi

echo "Checking Package Updates..."
pkg update -f
pkg upgrade -y

echo "Installing sudo and git..."
pkg install -y sudo git

echo "Installing MATE Desktop..."
pkg install -y xorg slim mate
echo "exec /usr/local/bin/mate-session" > ~/.xinitrc

echo "Installing Desktop Applications..."
pkg install -y cursor-dmz-theme setxkbmap xrandr dpkg fusefs-ntfs fusefs-ext4fuse
pkg install -y py27-gobject py27-webkitgtk py27-pexpect py27-python-distutils-extra
pkg install -y rsync gksu octopkg networkmgr transmission dconf-editor firefox firefox-i18n geany filezilla
