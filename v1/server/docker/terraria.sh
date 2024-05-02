#!/bin/bash
# Docker script for starting and setting up a terraria server

banner() {
cat << "EOF"
::::::::::::.,:::::: :::::::..  :::::::..    :::.    :::::::..   :::  :::.
;;;;;;;;'''';;;;'''' ;;;;``;;;; ;;;;``;;;;   ;;`;;   ;;;;``;;;;  ;;;  ;;`;;
     [[      [[cccc   [[[,/[[['  [[[,/[[['  ,[[ '[[,  [[[,/[[['  [[[ ,[[ '[[,
     $$      $$""""   $$$$$$c    $$$$$$c   c$$$cc$$$c $$$$$$c    $$$c$$$cc$$$c
     88,     888oo,__ 888b "88bo,888b "88bo,888   888,888b "88bo,888 888   888,
     MMM     """"YUMMMMMMM   "W" MMMM   "W" YMM   ""` MMMM   "W" MMM YMM   ""`
:::::::-.      ...       .,-:::::  :::  .   .,:::::: :::::::..
 ;;,   `';, .;;;;;;;.  ,;;;'````'  ;;; .;;,.;;;;'''' ;;;;``;;;;
 `[[     [[,[[     \[[,[[[         [[[[[/'   [[cccc   [[[,/[[['
  $$,    $$$$$,     $$$$$$        _$$$$,     $$""""   $$$$$$c
  888_,o8P'"888,_ _,88P`88bo,__,o,"888"88o,  888oo,__ 888b "88bo,
  MMMMP"`    "YMMMMMP"   "YUMMMMMP"MMM "MMP" """"YUMMMMMMM   "W"
EOF
}

WORLDDIR=$PWD/world

check_server() {
if [ ! -d $WORLDDIR ]; then
 	banner
        echo "No world found - Create one now? [y/N]"
        read input0
        if [[ ! "$input0" == "y" ]]; then
                echo "Exiting"
                exit 1
        fi
        mkdir -p $WORLDDIR
sudo docker run --name terraria -it -p 7777:7777 --memory "4g" --rm -v $WORLDDIR:/root/.local/share/Terraria/Worlds ryshe/terraria:latest -world /root/.local/share/Terraria/Worlds/world.wld -autocreate 2
fi
}
start_server() {
sudo docker run -d --rm -p 7777:7777 -v $WORLDDIR:/root/.local/share/Terraria/Worlds --name="terraria" -e WORLD_FILENAME="world.wld" ryshe/terraria:latest
#sudo podman start terraria
exit 1
}
stop_server() {
sudo docker stop terraria
exit 1
}
reset_server() {
sudo docker stop terraria
sudo rm -r $WORLDDIR
echo "Please rerun this script to generate a new world"
exit 1
}
interact_server() {
sudo docker exec -it terraria sh
exit 1
}

# Main

check_server

case $1 in
        "reset")
                echo "Are you sure you want to reset the world?"
                reset_server
                ;;
        "start")
                echo "Starting Terraria Server"
                start_server
                ;;
        "stop")
                echo "Stopping Terraria Server"
                stop_server
                ;;
	"interact")
		interact_server
		;;
        *)
                echo "Usage: $0... (start|stop|reset)"
                ;;
esac
exit 1

# EOM
