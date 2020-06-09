#/bin/bash
# Adds shell scripts to /usr/local/bin/
path=$1
filename=$2
bin='/usr/local/bin/'
status="false"

function checkPriv() {
  sudo -nv 2> /dev/null && true || false
}
function elevatePriv() {
  echo "[!] This script requires sudo privledges"
  sudo -v
  if ! checkPriv; then echo "[-] This script requires sudo privledges" && exit; fi
}
function install() {
  newpath="${bin}${filename}"
  echo "[*] Installing $path > $newpath"
  sudo chmod +x $path 2>&1 && status="true" || status="false"
  sudo cp $path $newpath 2>&1 && status="true" || status="false"
  if ! $status; then echo "[-] Failed to install $path to $newpath" && exit; fi
  echo "[+] Successfully installed $filename"
}

if ! checkPriv; then elevatePriv; fi
install

exit
