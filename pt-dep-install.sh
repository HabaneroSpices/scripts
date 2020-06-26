#!/bin/bash
#
tmpDir=/tmp/pt-dep-install

echo "[#] Spicy Installer by HabaneroSpices"
echo "-"
read -p '[!] Do you want to start the installation?(Y/n) ' pause_0
if [ "$pause_0" = "n" ];then echo "bye" && exit; fi

function install() {
sudo -v
echo "[*] Starting installation..."
sudo dpkg --configure -a >&- 2> /dev/null

echo "[*] Installing libqt dependencies..." 
sudo apt install -y libqt5webkit5 libqt5multimedia5 libqt5xml5 libqt5script5 libqt5scripttools5 2> /dev/null

echo "[*] Creating Tmp Folders..."
mkdir $tmpDir 2> /dev/null

echo "[*] Shoutout to SimpleFlips..."
cd $tmpDir 2> /dev/null

echo "[*] Downloading Dependencies(1/2)..."
sudo wget http://mirrors.kernel.org/ubuntu/pool/main/i/icu/libicu52_52.1-3ubuntu0.8_amd64.deb 2> /dev/null

echo "[*] Downloading Dependencies(2/2)..."
sudo wget http://ftp.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb 2> /dev/null

echo "[*] Installing Dependencies(1/2)..."
sudo dpkg -i libicu52_52.1-3ubuntu0.8_amd64.deb 2> /dev/null

echo "[*] Installing Dependencies(2/2)..."
sudo dpkg -i libpng12-0_1.2.50-2+deb8u3_amd64.deb 2> /dev/null

echo "[*] Removing Temp Files..."
sudo rm -rf $tmpDir 2> /dev/null
}

install
echo "[+] Installation complete!"
echo "-"
echo "[!] You may now open packetracer using...: packettracer"

exit