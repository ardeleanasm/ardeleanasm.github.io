---
layout: blog/post
title: "Latexdiff – sometimes is just a pain"
description: "Latexdiff – sometimes is just a pain"
category: latex
tags: latex
---

Just posting a command for **latexdiff** that saved me from trying to solve a lot of errors:

```
latexdiff --append-safecmd=subfile --config="PICTUREENV=(?:picture|DIFnomarkup|align|tabular)[\w\d*@]*" draft.tex revision.tex --flatten > diff_new.tex
```
