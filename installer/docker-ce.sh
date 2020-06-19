#!/bin/bash
#

install() {
    sudo -v
    echo '[*] Downloading...'
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh.tmp
    echo '[*] Installing...'
    sudo sh /tmp/get-docker.sh.tmp
    echo '[*] Cleaning up...'
    sudo rm -f /tmp/get-docker.sh
    echo '[!] Run docker without root?'
    read -p '[Y/n]: ' choice
    case $choice in [nN]* ) exit;; esac
    echo "[*] Adding $USER to docker group"
    sudo usermod -aG docker "$USER"
}

case $1 in

easy)
    install
    echo "Done."
    ;;
fuck)
    echo "Asshole. ouff"
    ;;
*)
    echo "Usage... $0 (easy|fuck)"
    ;;
esac
