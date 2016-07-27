#!/usr/bin/env sh

THIS_DIR=$(cd $(dirname $0); pwd)
GPORTS_DIR="/tmp/ghostbsd-ports"
TORCH_DIR="/opt/torch"

ZBS_VER="1.30"
ZBS_LNK="https://download.zerobrane.com/ZeroBraneStudioEduPack-${ZBS_VER}-linux.sh"

if [ -d "$GPORTS_DIR" ]; then
	read -p "Do you want to install GhostBSD-icons [y/N]?" yn </dev/tty
	case "$yn" in
		y|Y) echo "GhostBSD-icons is installing..."
			cd "${GPORTS_DIR}/x11-themes/ghostbsd-icons" && make install || exit 1
			GICONS_INSTALLED=true
			;;
		*) echo "Skip to install GhostBSD-icons."
			;;
	esac
	
	MATE_SESSION=$(which mate-session | head -n 1)
	if [ "$GICONS_INSTALLED" -a "$MATE_SESSION" == "/usr/local/bin/mate-session" ]; then
		read -p "Do you want to install GhostBSD-mate-themes [y/N]?" yn </dev/tty
		case "$yn" in
		  y|Y) echo "GhostBSD-mate-themes is installing..."
			cd "${GPORTS_DIR}/x11-themes/ghostbsd-mate-themes" && make install
			;;
		  *) echo "Skip to install GhostBSD-mate-themes."
			;;
		esac
	fi
fi

pkg install -y dropbox-api-command pip sox
pip install --upgrade pip

read -p "Do you want to install Torch [y/N]?" yn </dev/tty
case "$yn" in
	y|Y) echo "Torch is cloning..."
		mkdir -p "/opt"
		if [ ! -d "$TORCH_DIR" ]; then
			git clone https://github.com/torch/distro.git $TORCH_DIR --recursive
		fi
		echo "To install, please edit:"
		echo " -- ${TORCH_DIR}/install-deps"
		echo "    ImageMagick -> ImageMagick7"
		echo "    libzmq3     -> libzmq4"
		echo " -- ${TORCH_DIR}/exe/trepl/trepl-scm-1.rockspec"
		echo "    + incdirs = {\"/usr/local/include\"},"
		echo "    + libdirs = {\"/usr/local/lib\"}"
		echo " -- ${TORCH_DIR}/install.sh"
		echo "    + export LD_LIBRARY_PATH=\"/usr/local/lib/gcc48:\${LD_LIBRARY_PATH}\""
		echo "    + export CC=gcc"
		echo "    + export CXX=g++"
		echo "    + trepl-scm-1.rockspec"
		;;
	*) echo "Skip to clone Torch."
		;;
esac
