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

ERROR=0
LOG='/var/log/borg/verify.log'
export BACKUP_USER=''
export REPOSITORY_DIR=''

export REPOSITORY="ssh://${BACKUP_USER}@${BACKUP_USER}.your-storagebox.de:23/./backup/${REPOSITORY_DIR}"

##
## functions
##
function verifyIntegrity() {
	borg check -v $REPOSITORY
}

##
## Output to a logfile
##

exec > >(tee -ia ${LOG})
exec 2>&1

echo "###### Verify started: $(date) ######"

declare BORG_MOUNT_DIR=$(mktemp -d)
declare BORG_BACKUP_NAME=$(borg list $REPOSITORY | tail -n 1 | cut -d ' ' -f1)

borg mount $REPOSITORY::$BORG_BACKUP_NAME $BORG_MOUNT_DIR

# Look around, do you see your data?
cd $BORG_MOUNT_DIR
echo -e "\n!! Number of files: $(find . -type f | wc -l)" # Number of files
echo -e "!! Size of major dirs: \n$(du -hsc ./*)\n"       # Dirs and their size

# Cleanup
cd - >/dev/null
borg umount $BORG_MOUNT_DIR
rmdir $BORG_MOUNT_DIR >/dev/null

echo "@@ Verifying integrity"
ERROR=$(
	verifyIntegrity
	echo $?
)
if [ $ERROR -eq 0 ]; then
	echo "!! Integrity OK"
else
	echo "!! Integrity ERROR"
fi

echo "###### Verify ended: $(date) ######"

if [ ! $ERROR -eq 0 ]; then exit $ERROR; fi
