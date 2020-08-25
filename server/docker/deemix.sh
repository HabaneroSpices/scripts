#!/bin/bash
# Airsonic docker script

SCRIPTNAME=`basename "$0"`
DOWNLOADSDIR=$PWD/music
CONFIGDIR=$PWD/config

banner() {
cat << "EOF"
     _                     _
    | |                   (_)
  __| | ___  ___ _ __ ___  ___  __
 / _` |/ _ \/ _ \ '_ ` _ \| \ \/ /
| (_| |  __/  __/ | | | | | |>  <
 \__,_|\___|\___|_| |_| |_|_/_/\_\
EOF
}
if [ ! -d "$CONFIGDIR" ]; then
	banner
	echo "airsonic Server is not setup - setup now? [y/N]"
	read input0
	if [[ ! "$input0" = "y" ]]; then
		echo "Exiting"
		exit 1
	fi
	mkdir -p $DOWNLOADSDIR $CONFIGDIR
	docker run --name deemix --memory "4g" -e ARL=ARLGOESHERE -e UMASK_SET=022 -v $DOWNLOADSDIR:/downloads -v $CONFIGDIR:/config -p 6595:6595 -d registry.gitlab.com/bockiii/deemix-docker
fi
case $1 in
"start")
docker start deemix
;;
"stop")
docker stop deemix
;;
"reset")
sudo docker stop deemix
sudo docker rm deemix
;;
*)
echo "Usage: $SCRIPTNAME... (start|stop|reset)"
;;
esac
exit 1
