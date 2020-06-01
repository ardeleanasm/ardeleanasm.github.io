#!/usr/bin/env sh
#set -euo pipefail

SRC_BRANCH=source
TGT_BRANCH=master

STATUS="$(git status --porcelain)"
if [ -n "$STATUS" ]; then
	echo "Uncommitted changes"
	echo "$STATUS"
	exit
fi

git checkout $SRC_BRANCH
MSG=$(git log -n 1 --format="format:%h %f")
git checkout $TGT_BRANCH
rm -rf *
cp -r $RESULT/* .
chmod u+w . -R
git add .
git commit -m "$MSG"
git push
git checkout $SRC_BRANCH
