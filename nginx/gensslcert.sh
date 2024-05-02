#!/bin/bash
# Generates SSL Cert | CRT & KEY Valid for 1 year

error="💢"
warning="🚨"
info="💡"
success="✅"

screenName=$(basename "$0")

function gen() {
	openssl req -x509 \
		-sha256 -days 356 \
		-nodes \
		-newkey rsa:2048 \
		-subj "/CN=$1/C=US/L=$2" \
		-keyout $1.key -out $1.crt &&
		true || false
}

err() {
	echo -e "\n$error : $*" >&2
}

if [ -z "$1" ] || [ -z "$2" ]; then echo -e "\n$warning : Please provide at least two arguments\n$info : Usage: $screenName... [FQDN] [city]" && exit; fi

if ! gen "$1" "$2"; then err "Could not generate the certificate." && exit; fi

echo -e "\n$success : The certificate files has been generated."
