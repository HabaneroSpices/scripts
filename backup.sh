#!/bin/bash
# @weekly bash /srv/minecraft/backup.sh full > /tmp/backup_full.output
NOW=$(date +"%Y-%m-%d")
THIS_PATH=/srv/minecraft
BCK_PATH=/home/spices/backups
DIR=
ARG1=${1}

upload() {
    mega-put -c ${BCK_PATH}/minecraft${ARG1}_${NOW}.tar.gz /SERVER_BACKUP/SODEANIMEPIGER
}

decomPress() {
     tar cfz ${BCK_PATH}/minecraft${ARG1}_${NOW}.tar.gz ${DIR}
}

case ${ARG1} in
world)
    echo "Uploading world to backup server..."
    DIR=${THIS_PATH}/world/
    decomPress
    upload
    ;;
full)
    echo "Uploading ${THIS_PATH} to backup server..."
    DIR=${THIS_PATH}/
    decomPress
    upload
    ;;
*)
    echo "Usage... $0 (world|full)"
    ;;
esac
