#!/bin/bash
#
# VAR
tmpDir=/tmp/pt-dep-5974

# ERRH
set -Eeo pipefail
trap notify ERR
trap cleanup EXIT

function notify {
  echo "Somthing went wrong!"
  echo "${LINENO}: ${BASH_COMMAND}"
}
function cleanup {
  if [ -d "$tmpDir" ]; then
  rm -r $tmpDir
  fi
}
if ! [ -d "$tmpDir" ]; then mkdir $tmpDir; fi
cd $tmpDir

# MAIN
function install {
sudo -v
echo "[*] Downloading Dependencies(1/1)..."
wget http://mirrors.kernel.org/ubuntu/pool/main/i/icu/libicu52_52.1-3ubuntu0.8_amd64.deb 2> /dev/null
wget http://ftp.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb 2> /dev/null
echo "[*] Installing Dependencies(1/2)..."
sudo dpkg --configure -a >&- 2> /dev/null
sudo dpkg -i libicu52_52.1-3ubuntu0.8_amd64.deb 2> /dev/null
sudo dpkg -i libpng12-0_1.2.50-2+deb8u3_amd64.deb 2> /dev/null
echo "[*] Installing dependencies(2/2)..."
sudo apt install -y libqt5webkit5 libqt5multimedia5 libqt5xml5 libqt5script5 libqt5scripttools5 2> /dev/null
}

#  START
install
echo "Done!"
exit