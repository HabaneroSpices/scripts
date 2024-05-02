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

# Execution

set -e
set -o pipefail
set -C

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
DIR_NAME=$(basename "${DIR}")
SCRIPT_NAME=$(basename "${0}")

lockfile="/tmp/${DIR_NAME}.lock"
if echo "$$" >"$lockfile"; then
	log "Successfully acquired lock"
	main "${@}"
	rm "$lockfile"
else
	log "Cannot acquire lock - already locked by $(cat "$lockfile")"
	exit 1
fi

exit $?
