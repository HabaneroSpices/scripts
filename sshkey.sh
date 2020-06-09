#/bin/bash
# Adds every key in foreign-keys to authorized_keys

sshDir="/home/spices/.ssh"
section="sshkey"
auth="authorized_keys"
authTmp="${auth}.out.tmp"
allKeys=[]

cd $sshDir

function scrape() {
  i=0
  for filename in keys/*@id_rsa.pub; do
	allKeys[$i]=$filename
	((i++))
  done
}

function remove() {
  sed "/<!-- ${section} -->/,/<!-- end -->/d" $auth > $authTmp
}

function prepare() {
  echo "<!-- ${section} -->" >> $authTmp
  for x in "${allKeys[@]}"; do
	cat $x >> $authTmp
  done
  echo "<!-- end -->" >> $authTmp
}

function write() {
  cp $authTmp $auth
  rm -f $authTmp
}

case ${1} in
"add")
   scrape
   remove
   prepare
   write
   ;;
"remove")
   remove
   write
   ;;
*)
   echo "Usage... ${0} (add|remove)"
esac

exit

