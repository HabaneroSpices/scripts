#!/bin/bash
# Navidrome docker script - v1.5

SCRIPTNAME=`basename "$0"`
DATADIR=$PWD/data
MUSICDIR=$PWD/music
IMAGENAME=deluan/navidrome:develop

setup_docker() {
docker run --name navidrome --memory "4g" -v $DATADIR:/data -v $MUSICDIR:/music:ro -e ND_BASEURL=/navidrome -e ND_ENABLETRANSCODINGCONFIG=true -p 4533:4533 -d $IMAGENAME
}

banner() {
cat << "EOF"
 __   _ _______ _    _ _____ ______   ______  _____  _______ _______
 | \  | |_____|  \  /    |   |     \ |_____/ |     | |  |  | |______
 |  \_| |     |   \/   __|__ |_____/ |    \_ |_____| |  |  | |______
EOF
}
if [ ! -d "$DATADIR" ]; then
	banner
	echo "Navidrome is not setup - setup now? [y/N]"
	read input0
	if [[ ! "$input0" = "y" ]]; then
		echo "Exiting"
		exit 1
	fi
	mkdir -p $DATADIR $MUSICDIR
	touch $DATADIR/navidrome.toml
	setup_docker
fi
case $1 in
"start")
docker start navidrome
;;
"stop")
docker stop navidrome
;;
"reset")
docker stop navidrome
docker rm navidrome
docker rmi $IMAGENAME
setup_docker
;;
*)
echo "Running: $IMAGENAME"
echo "Usage: $SCRIPTNAME... (start|stop|reset)"
;;
esac
