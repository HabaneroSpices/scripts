#!/bin/bash
#
DIR=/srv/usc-server
WDIR=$DIR/update
TDIR=$WDIR/temp
DDIR=$WDIR/download
BDIR=$WDIR/build

function get() {
rm -r $WDIR
mkdir -p $TDIR $DDIR $BDIR
wget https://github.com/itszn/usc-multiplayer-server/zipball/master -O $DDIR/master.zip
unzip $DDIR/master.zip -d $TDIR
mv $TDIR/*/* $BDIR
}

function build() {
cd src
# Install dependencies
go get
# Build from source
go build
}

function finish() {
mv $BDIR/src/usc_multiplayer $DIR/bin/usc_140.linux
rm -r $WDIR
}

cd $WDIR
get
cd $BDIR
build
cd $DIR
finish
