#!/bin/bash
# Installs service file for systemd

sudo cp $PWD/usc-server.service /etc/systemd/system/
mkdir -p $PWD/bin
$PWD/update.sh
sudo systemctl daemon-reload
exit 1
