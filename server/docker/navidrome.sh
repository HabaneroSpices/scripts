#!/bin/bash
# Navidrome docker script

SCRIPTNAME=`basename "$0"`
DATADIR=$PWD/data
MUSICDIR=$PWD/music

banner() {
cat << "EOF"
 __   _ _______ _    _ _____ ______   ______  _____  _______ _______
 | \  | |_____|  \  /    |   |     \ |_____/ |     | |  |  | |______
 |  \_| |     |   \/   __|__ |_____/ |    \_ |_____| |  |  | |______
EOF
}
if [ ! -d "$DATADIR" ]; then
	banner
	echo "Navidrome Server is not setup - setup now? [y/N]"
	read input0
	if [[ ! "$input0" = "y" ]]; then
		echo "Exiting"
		exit 1
	fi
	mkdir -p $DATADIR $MUSICDIR
	docker run --name navidrome --memory "4g" -v $DATADIR:/data -v $MUSICDIR:/music:ro -p 4533:4533 -d deluan/navidrome:develop
fi
case $1 in
"start")
docker start navidrome
;;
"stop")
docker stop navidrome
;;
"reset")
sudo docker stop navidrome
sudo docker rm navidrome
sudo docker rmi deluan/navidrome:develop
;;
*)
echo "Usage: $SCRIPTNAME... (start|stop|reset)"
;;
esac
