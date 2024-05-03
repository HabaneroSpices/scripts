#!/usr/bin/env bash
#
# Keep any github repo up-to-date with remote-upstream.
# Use together with cron like: * * * * * /usr/bin/bash /path/to/repo/update.sh
#
# Features:
# - Run lock, script will never run twice.
# - Automatic stashing
#
function main() {
	cd $DIR

	if [ "$CRON" = true ]; then
		isCron=$()
		if crontab -l | grep $DIR/update.sh > /dev/null; then
		log "Cronjob for `pwd`/update.sh already configured"
		else
		crontab -l | { cat; echo "* * * * * /usr/bin/bash `pwd`/update.sh"; } | crontab - && log "Added cronjob for `pwd`/update.sh" || log "Could not add cronjob for `pwd`/update.sh"
		fi
	fi

	log "Fetching remote repository..."
	git fetch || exit 1

	UPSTREAM=${1:-'@{u}'}
	LOCAL=$(git rev-parse @)
	REMOTE=$(git rev-parse "$UPSTREAM")
	BASE=$(git merge-base @ "$UPSTREAM")

	if [ $LOCAL = $REMOTE ]; then
		log "No changes detected in remote upstream"
	elif [ $LOCAL = $BASE ]; then
		BUILD_VERSION=$(git rev-parse HEAD)
		log "Changes detected, deploying new version: $BUILD_VERSION"
		deploy
	elif [ $REMOTE = $BASE ]; then
		log "Local changes detected, stashing"
		git stash || exit 1
		deploy
	else
		log "Git is diverged, manual action required"
		exit 1
	fi
}

function deploy() {
	git pull || exit 1
}

function log() {
	local TIMESTAMP=$(date --utc +%FT%T)
	echo "${TIMESTAMP}: ${*}"
}

function on-exit() {
	rm "$lockfile"
}
function usage() {
      echo "Usage: ${SCRIPT_NAME}... [--cron]"
}
function parse-opts() {
	CRON=false
	[[ "${*}" == *"--cron"* ]] && CRON=true
}

# Execution
set -C
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
DIR_NAME=$(basename "${DIR}")
SCRIPT_NAME=$(basename "${0}")

parse-opts "${@}"

trap on-exit SIGINT SIGTERM EXIT ERR
lockfile="/tmp/${DIR_NAME}.lock"
if echo "$$" >"$lockfile"; then
	log "Successfully acquired lock"
	main
else
	log "Cannot acquire lock - already locked by $(cat "$lockfile")"
	exit 1
fi

exit $?
