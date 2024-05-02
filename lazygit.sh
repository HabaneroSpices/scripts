#/bin/bash
# Add, commit, push
git add .
case $* in
"")
	git commit -a -m "Lazygit"
	;;
*)
	git commit -a -m "$*"
	;;
esac
git push
exit
