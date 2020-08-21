#!/bin/bash
# Airsonic docker script

SCRIPTNAME=`basename "$0"`
DATADIR=$PWD/data
MUSICDIR=$PWD/music
PLAYLISTDIR=$PWD/playlists
PODCASTDIR=$PWD/podcasts

banner() {
cat << "EOF"
 _______ _____  ______ _______  _____  __   _ _____ _______
 |_____|   |   |_____/ |______ |     | | \  |   |   |
 |     | __|__ |    \_ ______| |_____| |  \_| __|__ |_____
EOF
}
if [ ! -d "$DATADIR" ]; then
	banner
	echo "airsonic Server is not setup - setup now? [y/N]"
	read input0
	if [[ ! "$input0" = "y" ]]; then
		echo "Exiting"
		exit 1
	fi
	mkdir -p $DATADIR $MUSICDIR $PLAYLISTDIR $PODCASTDIR
	docker run --name airsonic --memory "4g" -v $DATADIR:/airsonic/data -v $MUSICDIR:/airsonic/music -v $PLAYLISTDIR:/airsonic/playlists -v $PODCASTDIR:/airsonic/podcasts -p 4040:4040 -d airsonic/airsonic
fi
case $1 in
"start")
docker start airsonic
;;
"stop")
docker stop airsonic
;;
"reset")
sudo docker stop airsonic
sudo docker rm airsonic
sudo docker rmi airsonic/airsonic
;;
*)
echo "Usage: $SCRIPTNAME... (start|stop|reset)"
;;
esac
