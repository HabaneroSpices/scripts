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
	docker run --name deemix --memory "4g" -e ARL=ddd763a38fb3add792b3784c3867cc5b048cb00dffa390d6dd5f4a1ced138a091f706123901ee1159f711361d13422fff461ac606e16f4621a1a0d471598915088b1bf49ca95044f89ce4f29ae252d4d540c88f75dfa15f4d155163b6de3a824 -e UMASK_SET=022 -v $DOWNLOADSDIR:/downloads -v $CONFIGDIR:/config -p 6595:6595 -d registry.gitlab.com/bockiii/deemix-docker
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
sudo docker rmi registry.gitlab.com/bockiii/deemix-docker
;;
*)
echo "Usage: $SCRIPTNAME... (start|stop|reset)"
;;
esac
exit 1
