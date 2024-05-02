#!/usr/bin/env bash

##
## Set environment variables
##

## if you don't use the standard SSH key,
## you have to specify the path to the key like this
# export BORG_RSH='ssh -i /home/userXY/.ssh/id_ed25519'

## You can save your borg passphrase in an environment
## variable, so you don't need to type it in when using borg
export BORG_PASSPHRASE=''

##
## Set some variables
##

LOG='/var/log/borg/backup.log'
export BACKUP_USER=''
export REPOSITORY_DIR=''

export REPOSITORY="ssh://${BACKUP_USER}@${BACKUP_USER}.your-storagebox.de:23/./backup/${REPOSITORY_DIR}"

##
## functions
##

function checkPath() {
	local output_arr=()
	for i in ${@}; do
		if [[ -e "${i}" ]]; then
			output_arr+=("${i}")
		fi
	done
	echo "${output_arr[*]}"
}

function prependExclude() {
	local output_arr=()
	for i in ${@}; do
		output_arr+=("--exclude ${i}")
	done
	echo "${output_arr[*]}"
}

##
## Output to a logfile
##

exec > >(tee -ia ${LOG})
exec 2>&1

echo "###### Backup started: $(date) ######"

declare -a include_backup="$(checkPath "/root" "/etc" "/var/www" "/srv" "/home" "/usr/local/bin")"
declare -a exclude_backup="$(prependExclude "/dev" "/proc" "/sys" "/var/run" "/run" "/lost+found" "/mnt" "/var/lib/lxcfs")"

echo "Transfer files ..."
borg create -v --stats \
	$REPOSITORY::'{now:%Y-%m-%d_%H:%M}' \
	${include_backup[*]} \
	${exclude_backup[*]}

echo "###### Backup ended: $(date) ######"
