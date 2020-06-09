#/bin/bash
# Add, commit, push
git add .
case $* in
"")
  git commit -a -m "Update"
  ;;
*)
  git commit -a -m "$*"
  ;;
esac
git push
exit
