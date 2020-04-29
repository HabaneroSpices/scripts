#!/bin/bash
#

install_debian() {
    sudo -v
    echo '-------------'
    echo 'Removing old docker components...'
    echo '-------------'

    sudo apt-get remove -y docker docker-engine docker.io containerd runc

    echo '-------------'
    echo 'Installing prerequisites...'
    echo '-------------'

    sudo apt-get update

    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

    echo '-------------'
    echo 'Adding docker repo...'
    echo '-------------'

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo apt-key fingerprint 0EBFCD88

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    echo '-------------'
    echo 'Installing docker...'
    echo '-------------'

    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
}

case $1 in

apt)
    echo "Installing..."
    install_debian
    echo "Done."
    ;;
yum)
    echo "Asshole. ouff"
    ;;
*)
    echo "Usage... $0 (apt|yum)"
    ;;

esac
