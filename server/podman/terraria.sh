#!/bin/bash
# Start script for Terraria Server using podman

WORLDDIR=$PWD/world

check_server() {
if [ ! -d $WORLDDIR ]; then
        echo "No world found - Create one now? [y/N]"
        read input0
        if [[ ! "$input0" == "y" ]]; then
                echo "Exiting"
                exit 1
        fi
        mkdir -p $WORLDDIR
sudo podman run --name terraria -it -p 7777:7777 --rm -v $WORLDDIR:/root/.local/share/Terraria/Worlds ryshe/terraria:latest -world /root/.local/share/Terraria/Worlds/world.wld -autocreate 2
fi
}
start_server() {
sudo podman run -d --rm -p 7777:7777 -v $WORLDDIR:/root/.local/share/Terraria/Worlds --name="terraria" -e WORLD_FILENAME="world.wld" ryshe/terraria:latest
#sudo podman start terraria
exit 1
}
stop_server() {
sudo podman stop terraria
exit 1
}
reset_server() {
exit 1
}
interact_server() {
sudo podman exec -it terraria sh
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
