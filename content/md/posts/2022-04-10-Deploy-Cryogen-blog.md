{
 :title "Deploy Cryogen blog on Github"
 :layout :post
 :tags  ["shell script"]
 :toc true}

---

```
SOURCE_BRANCH = "dev"
MASTER_BRANCH = "master"

# checkout correct branch
git checkout $SOURCE_BRANCH


# build
lein run

# stash
git stash

# checkout master branch
git checkout $MASTER_BRANCH
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
```