#!/bin/bash
# Installs service file for systemd

sudo cp $PWD/usc-server.service /etc/systemd/system/
$PWD/update.sh
sudo systemctl daemon-reload
exit 1
