#/bin/bash
# Docker launch script for Minecraft Vanilla - ported to podman

banner() {
cat << "EOF"
.        :     .,-:::::
;;,.    ;;;  ,;;;'````'
[[[[, ,[[[[, [[[
$$$$$$$$"$$$ $$$
888 Y88" 888o`88bo,__,o,
MMM  M'  "MMM  "YUMMMMMP"
::::::::::.    ...    :::::::-.  .        :    :::.   :::.    :::.
 `;;;```.;;;.;;;;;;;.  ;;,   `';,;;,.    ;;;   ;;`;;  `;;;;,  `;;;
  `]]nnn]]',[[     \[[,`[[     [[[[[[, ,[[[[, ,[[ '[[,  [[[[[. '[[
   $$$""   $$$,     $$$ $$,    $$$$$$$$$$"$$$c$$$cc$$$c $$$ "Y$c$$
   888o    "888,_ _,88P 888_,o8P'888 Y88" 888o888   888,888    Y88
   YMMMb     "YMMMMMP"  MMMMP"`  MMM  M'  "MMMYMM   ""` MMM     YM
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
sudo podman run -e EULA=TRUE -e ENABLE_AUTOPAUSE=TRUE -d -v $PWD/data:/data -p 25565:25565 --name mc itzg/minecraft-server
else
sudo podman run -e VERSION="$input1" -e EULA=TRUE -e ENABLE_AUTOPAUSE=TRUE -d -v $PWD/data:/data -p 25565:25565 --name mc itzg/minecraft-server
fi
fi
case $1 in
start)
sudo podman start mc
;;
stop)
sudo podman stop mc
;;
log)
sudo podman logs -f mc
;;
cli)
sudo podman exec -i mc rcon-cli
;;
*)
echo "Usage... $0 (start|stop|log|cli)"
;;
esac
exit
