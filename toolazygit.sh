#!/usr/bin/env bash
#
# Add, commit, push
#
git add .
case $* in
"")
	git commit -a -m "Modified"
	;;
*)
	git commit -a -m "$*"
	;;
esac
git push
