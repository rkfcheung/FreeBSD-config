#!/usr/bin/env sh

THIS_DIR=$(cd $(dirname $0); pwd)

GPORTS_DIR="/tmp/ghostbsd-ports"
GICONS_NAME="ghostbsd-icons"
GTHEME_NAME="ghostbsd-mate-themes"

TORCH_DIR="/opt/torch"

ZBS_VER="1.30"
ZBS_SH="ZeroBraneStudioEduPack-${ZBS_VER}-linux.sh"
ZBS_LNK="https://download.zerobrane.com/${ZBS_SH}"

RS_DIR="${THIS_DIR}/ports/devel/rstudio"
RS_VER="0.98.490"
RS_TGZ="rstudio-rstudio-v${RS_VER}_GH0.tar.gz"
RS_GH="https://codeload.github.com/rstudio/rstudio/tar.gz/v${RS_VER}?dummy=/${RS_TGZ}"
RS_SHAR="rstudio.shar"
RS_LNK="http://people.freebsd.org/~zi/${RS_SHAR}"

if [ -d "$GPORTS_DIR" ]; then
	GICONS_INFO=`pkg info ${GICONS_NAME} | head -n 1`
	if echo "$GICONS_INFO" | grep -q "$GICONS_NAME"; then
		echo "$GICONS_INFO is installed."
		yn="N"
		GICONS_INSTALLED=true
	else
		read -p "Do you want to install ${GICONS_NAME} [y/N]?" yn </dev/tty
	fi
	case "$yn" in
		y|Y) echo "${GICONS_NAME} is installing..."
			cd "${GPORTS_DIR}/x11-themes/${GICONS_NAME}" && make install || exit 1
			GICONS_INSTALLED=true
			;;
		*) echo "Skip to install ${GICONS_NAME}."
			;;
	esac

	GTHEME_INFO=`pkg info ${GTHEME_NAME} | head -n 1`
	if echo "$GTHEME_INFO" | grep -q "$GTHEME_NAME"; then
		echo "$GTHEME_INFO is installed."
	else
		MATE_SESSION=$(which mate-session | head -n 1)
	fi
	if [ "$GICONS_INSTALLED" -a "$MATE_SESSION" == "/usr/local/bin/mate-session" ]; then
		read -p "Do you want to install ${GTHEME_NAME} [y/N]?" yn </dev/tty
		case "$yn" in
		  y|Y) echo "${GTHEME_NAME} is installing..."
			cd "${GPORTS_DIR}/x11-themes/${GTHEME_NAME}" && make install
			;;
		  *) echo "Skip to install ${GTHEME_NAME}."
			;;
		esac
	fi
fi

#pkg install -y dropbox-api-command py27-pip sox
#pip install --upgrade pip

TH=$(ls ${TORCH_DIR}/install/bin/th | head -n 1)
if [ ! -x "$TH" ]; then
	read -p "Do you want to install Torch [y/N]?" yn </dev/tty
else
	echo "Torch is installed."
	yn="N"
fi
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

ZBS_FILE=$(ls /tmp/${ZBS_SH} | head -n 1)
if [ ! -x "$ZBS_FILE" ]; then
	read -p "Do you want to install Zero Brane Studio [y/N]?" yn </dev/tty
else
	echo "${ZBS_SH} is downloaded."
	ls -l /opt/zbstudio/zbstudio.sh && echo "Zero Brane Studio is installed."
	yn="N"
fi
case "$yn" in
	y|Y) echo "Zero Brane Studio is downloading..."
		echo "File: $ZBS_LNK"
		cd /tmp && fetch $ZBS_LNK
		if [ -f "/tmp/${ZBS_SH}" ]; then
			cd /tmp 
			chmod +x $ZBS_SH
			echo "cd /bin && ln -s /usr/local/bin/bash"
			bash $ZBS_SH &
			echo "zbstudio.sh:"
			echo " + ARCH=\"x86\""
			echo "src/main.lua:"
			echo " + arch=\"x86\""
			echo "/usr/local/share/applications/zbstudio.desktop:"
			echo " -> Exec=/opt/zbstudio/zbstudio.sh %F"
		fi
		;;
	*) echo "Skip to install Zero Brane Studio."
		;;
esac

RS_FILE=$(ls /usr/ports/distfiles/rstudio/${RS_TGZ} | head -n 1)
if [ ! -x "$RS_FILE" ]; then
	read -p "Do you want to install RStudio [y/N]?" yn </dev/tty
else
	echo "${RS_TGZ} is downloaded."
	yn="N"
fi
case "$yn" in
	y|Y) echo "RStudio is downloading..."
		mkdir -p /usr/ports/distfiles/rstudio
		cd /usr/ports/distfiles/rstudio
		fetch $RS_GH
		cp $RS_TGZ "v${RS_VER}.tar.gz"
		echo "RStudio is installing..."
		cd ${RS_DIR} && make installl
		;;
	*) echo "Skip to install RStudio."
		;;
esac	
