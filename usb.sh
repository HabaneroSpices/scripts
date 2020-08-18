#/bin/bash
# Singe parameter mounting - usb v0.2
## Need trap on error and SIGTERM 

USBID="sdb1"
USBINT=/mnt/usb-device/
USBUSR=/home/madsc/usb-device/
sudo -v

case $1 in
	"mount")
		sudo mkdir -p ${USBINT}
		sudo ln -s ${USBINT} /home/madsc/ 2> /dev/null
		#sudo chown -R $USER:$USER ${USBINT}
		sudo mount /dev/${USBID} ${USBINT}
		#sudo chown -R $USER:$USER ${USBINT}
		;;
	"eject")
		sudo umount /dev/${USBID}
		#trap "exit" ERR
		#unlink ${USBUSR}
		;;
	*)
		echo "Usage: $0... (mount|eject)"
		;;
esac
