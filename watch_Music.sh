#!/bin/bash
#
DIRTARGET=/home/madsc/mnt/gdrive1/Music/
DIRSRC=/home/madsc/mnt/buffer/Music/
folder=/home/madsc/mnt/buffer/Music/

cd $folder

function check() {
array=(*/*/)
for dir in "${array[@]}"; do
parentdir="$(dirname "$dir")"
  if [ -f "${dir}cover.jpg" ]; then
	echo "${dir}cover.jpg :)"
	mkdir -p "${DIRTARGET}$parentdir/"
	echo "== $(date) : Moving, ${dir} > ${DIRTARGET}$parentdir/"
	mv "${dir}" "${DIRTARGET}$parentdir/"
	#echo "== $(date) : Removing, ${dir}"
	#rm -r "${dir}"
  else
	echo "${dir}cover.jpg :("
  fi
done
#array=''
}

#check

inotifywait -m -r -e create -e moved_to --format "%f" $DIRSRC \
| while read FILENAME
do
check
echo "== $(date) : executed, continuing to monitor..."
done
