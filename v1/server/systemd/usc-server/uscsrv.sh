#/bin/bash
# USC_Multiplayer
PORT=39079
DEBUG=0
PASSWORD=
REFRESH=50
EXEC=usc_140.linux


cp /dev/null /srv/usc-server/game.log

if [ $DEBUG -eq 1 ]; then
/srv/usc-server/bin/$EXEC -bind "0.0.0.0:$PORT" -password "$PASSWORD" -refresh $REFRESH -debug -verbose > /srv/usc-server/game.log
else
/srv/usc-server/bin/$EXEC -bind "0.0.0.0:$PORT" -password "$PASSWORD" -refresh $REFRESH > /srv/usc-server/game.log
fi

exit 1
