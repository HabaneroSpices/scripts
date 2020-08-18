#!/bin/bash
# Docker launch script for Minecraft Spigot

banner() {
cat << "EOF"
.        :     .,-:::::
;;,.    ;;;  ,;;;'````'
[[[[, ,[[[[, [[[
$$$$$$$$"$$$ $$$
888 Y88" 888o`88bo,__,o,
MMM  M'  "MMM  "YUMMMMMP"
:::::::-.      ...       .,-:::::  :::  .   .,:::::: :::::::..
 ;;,   `';, .;;;;;;;.  ,;;;'````'  ;;; .;;,.;;;;'''' ;;;;``;;;;
 `[[     [[,[[     \[[,[[[         [[[[[/'   [[cccc   [[[,/[[['
  $$,    $$$$$,     $$$$$$        _$$$$,     $$""""   $$$$$$c
  888_,o8P'"888,_ _,88P`88bo,__,o,"888"88o,  888oo,__ 888b "88bo,
  MMMMP"`    "YMMMMMP"   "YUMMMMMP"MMM "MMP" """"YUMMMMMMM   "W"
EOF
}

if [ ! -d "$PWD/data/" ]; then
	banner
	echo "MC Server is not setup - setup now? [y/N]"
	read input0
	if [[ ! "$input0" = "y" ]]; then
		echo "Exiting"
		exit 1
	fi

mkdir $PWD/data/
echo "MC Version? (empty for latest)"
read input1
if [ "$input1" == "" ]; then
sudo docker run -e EULA=TRUE -e TYPE=PAPER -e ENABLE_AUTOPAUSE=TRUE -d -p 25565:25565 -v $PWD/data:/data --name mc itzg/minecraft-server
else
sudo docker run -e VERSION="$input1" -e TYPE=PAPER -e EULA=TRUE -e ENABLE_AUTOPAUSE=TRUE -d -p 25565:25565 -v $PWD/data:/data --name mc itzg/minecraft-server
fi
fi
case $1 in
start)
sudo docker start mc
;;
stop)
sudo docker stop mc
;;
log)
sudo docker logs -f mc
;;
cli)
sudo docker exec -i mc rcon-cli
;;
*)
echo "Usage... $0 (start|stop|log|cli)"
;;
esac
exit 1
