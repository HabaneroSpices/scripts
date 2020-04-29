#!/bin/sh
#
SCREEN_NAME=usc_server
USC_SERVER_PATH=`cat ./.settings`
REFRESH=${2}

cd ${USC_SERVER_PATH}

check_server() {

    a=`screen -ls | grep "${SCREEN_NAME}"`
    if [ ${#a} -gt 0 ]
    then
        echo "0"
    else
        echo "1"
    fi
}
IS_SERVER_RUNNING=`check_server`

start_server() {
	> ${SCREEN_NAME}.log
	echo "Starting server..."
	screen -AmdS ${SCREEN_NAME} -L -Logfile ${SCREEN_NAME}.log ./${SCREEN_NAME}.linux ${REFRESH}
	echo ">Server started."
}

stop_server() {
    echo "Stopping server..."
    screen -S ${SCREEN_NAME} -X quit
    echo ">Server Stopped"
}

update_server() {
    echo "Downloading usc_server v1.3.0..."
    sudo wget -O ${SCREEN_NAME}.linux https://github.com/itszn/usc-multiplayer-server/releases/download/1.3.0/usc_multiplayer.v1.3.0.linux
    sudo chmod +x ${SCREEN_NAME}.linux
    echo ">Done."
}

case $1 in
start)
    if [ ${IS_SERVER_RUNNING} -eq 0 ]
    then
        echo "Server is already running. \nExiting..."
    else
        start_server
    fi    
    ;;

stop)
    if [ ${IS_SERVER_RUNNING} -eq 0 ]
    then
        stop_server
    else
        echo "Server doesn't seem to be running. \nExiting..."
    fi
    ;;
restart)
    if [ ${IS_SERVER_RUNNING} -eq 0 ]
    then
        echo "Restarting server..."
        stop_server
        start_server
    else
        echo "Server doesn't seem to be running. \nExiting..."
    fi
    ;;
status)
    if [ ${IS_SERVER_RUNNING} -eq 0 ]
    then
        echo "Server is running."
    else
        echo "Server is not running."
    fi
    ;;
update)
    update_server
    ;;
*)
    echo "Usage... $0 (start|restart|stop|status|update)"
    ;;
esac
