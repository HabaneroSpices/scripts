#!/bin/bash
#
# VAR
tmpDir=/tmp/get-docker-54631

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

#MAIN
install() {
    sudo -v
    echo '[*] Downloading...'
    curl -fsSL https://get.docker.com -o get-docker.sh
    echo '[*] Installing...'
    sudo dpkg --configure -a >&-
    sudo sh get-docker.sh
    echo '[!] Run docker without root?'
    read -p '[Y/n]: ' choice
    case $choice in [nN]* ) exit;; esac
    echo "[*] Adding $USER to docker group"
    sudo usermod -aG docker "$USER"
}

# START
case $1 in

"easy")
    install
    echo "Done."
    ;;
"haha")
    echo "Asshole. ouff"
    ;;
*)
    echo "Usage... $0 (easy|haha)"
    ;;
esac
exit