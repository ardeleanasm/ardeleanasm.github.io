#!/usr/bin/env sh


# temporarily store uncommited changes
git stash

# checkout correct branch
git checkout source

#build new files

#get previous files
git fetch --all
git checkout -b master --track origin/master

sh ./build.sh

#overwrite
rm -r posts/
cp -a output/. .
rm -r output

git add -A
git commit -m "Publish."

git push origin master:master

git checkout source
git branch -D master
git stash pop
