SOURCE_BRANCH = dev
MASTER_BRANCH = master

# checkout correct branch
git checkout dev 


# build
lein run

# stash 
git stash

# checkout master branch
git checkout master
git fetch --all
git stash pop
cp -r public/blog/* blog/
cp -r public/blog/404.html .
cp -r public/blog/cryogen.xml .
cp -r public/blog/feed.xml .
cp -r public/blog/index.html .
cp -r public/blog/sitemap.xml .

git commit -m "Publish"
git push

