#!/bin/bash
# Deemix docker script - v1.5

SCRIPTNAME=`basename "$0"`
DOWNLOADSDIR=$PWD/music
CONFIGDIR=$PWD/config
IMAGENAME=registry.gitlab.com/bockiii/deemix-docker
ARL="ARL_GOES_HERE"

setup_docker() {
docker run --name deemix -e ARL=$ARL -e UMASK_SET=022 -v $DOWNLOADSDIR:/downloads -v $CONFIGDIR:/config -p 6595:6595 -d $IMAGENAME
}

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
	echo "Deemix-web is not setup - setup now? [y/N]"
	read input0
	if [[ ! "$input0" = "y" ]]; then
		echo "Exiting"
		exit 1
	fi
	mkdir -p $DOWNLOADSDIR $CONFIGDIR
	setup_docker
fi
case $1 in
"start")
docker start deemix
;;
"stop")
docker stop deemix
;;
"reset")
docker stop deemix
docker rm deemix
docker rmi $IMAGENAME
setup_docker
;;
*)
echo "Running: $IMAGENAME"
echo "Usage: $SCRIPTNAME... (start|stop|reset)"
;;
esac
exit 1
