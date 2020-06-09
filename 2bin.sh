#/bin/bash
# Adds shell scripts to /usr/local/bin/
path=$1
filename=$2
bin='/usr/local/bin/'

function checkPriv() {
  sudo -nv 2> /dev/null && true || false
}
function elevatePriv() {
  echo "[!] This script requires sudo privledges"
  sudo -v
  if ! checkPriv; then echo "[-] This script requires sudo privledges" && exit; fi
}
function install() {
  echo "$path $filename"
  newpath="${bin}${filename}"
  sudo cp $path $newpath
}

if ! checkPriv; then elevatePriv; fi
install

exit
