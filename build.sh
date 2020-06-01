#!/usr/bin/env bash


OUTDIR=${out:-output}
mkdir -p "$OUTDIR/posts"
TMP=${TMPDIR:-$(mktemp -d)}

echo "<div class=\"header\"> <a href=\"../blog.html\">&larr; Posts</a> </div>" > "$TMP/back.html"

echo "<div class=\"footer\">Built on $(date +"%Y-%m-%d") at $(git rev-parse --short HEAD)</div>" > "$TMP/footer.html"

for post in $(find posts/ -type f | sort -r); do
	pandoc "$post" -o "$OUTDIR/${post%.md}.html" --standalone -c ../css/blogstyle.css \
 		--include-before-body="$TMP/back.html" \
 		--include-after-body="$TMP/back.html"

 	pandoc "$post" -t markdown --template=blog_template -V url="${post%.md}.html" >> "$TMP/toc.md"
done

pandoc blog.md "$TMP/toc.md" -o "$OUTDIR/blog.html" --standalone -c css/blogstyle.css \
 	--include-after-body="$TMP/footer.html" 





# Copy front page
cp -r css/ "$OUTDIR"
cp -r font-awesome-4.1.0/ "$OUTDIR"
cp -r fonts/ "$OUTDIR"
cp -r img/ "$OUTDIR"
cp -r js/ "$OUTDIR"
cp index.html "$OUTDIR"
