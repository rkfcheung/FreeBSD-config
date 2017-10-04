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
echo "Adding Destktop Environment Services..."
echo "" >> /etc/rc.conf
echo "# Desktop Environment Services" >> /etc/rc.conf
echo 'dbus_enable="YES"' >> /etc/rc.conf
echo 'hald_enable="YES"' >> /etc/rc.conf
echo 'slim_enable="YES"' >> /etc/rc.conf
echo "exec /usr/local/bin/mate-session" > ~/.xinitrc

echo "Installing Desktop Applications..."
pkg install -y cursor-dmz-theme setxkbmap xrandr dpkg fusefs-ntfs fusefs-ext4fuse
pkg install -y py27-gobject py27-webkitgtk py27-pexpect py27-python-distutils-extra
pkg install -y grsync gksu octopkg networkmgr transmission firefox firefox-i18n geany filezilla
pkg install -y droid-fonts-ttf chinese/fcitx zh-fcitx-configtool chinese/fcitx-chewing
