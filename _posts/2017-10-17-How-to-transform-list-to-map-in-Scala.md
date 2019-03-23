---
layout: post
title: "How to transform a List to a Map in Scala"
description: ""
category: functional programming
tags: [scala]
---

Yesterday I faced a new, for me at least, problem when I wanted to read a file line by line into a List and transform the result to a Map. 

Basically, I had a file ( from Rosalind) like the one below, a file in FASTA format.

```
>Tag_XXXX
string
>Tag_YYYY
string
>Tag_ZZZZ
string
```

A FASTA file contains a labels that starts with '>' character and the associated information on the next line. So it seemed normally to use a Map instead of a List.

So, I started by reading the file in a `List[String]`

```scala
val lines: Option[List[String]] = {
    if (Files.exists(Paths.get(filePath))) {
      Some(Source.fromFile(filePath, "UTF-8").getLines().toList)
    } else {
      None
    }
```

The next step was to zip lines two by two and filter only the one that contains '>'

```scala
lines.get.zip(lines.get.tail).filter { case (k, _) => k.contains('>') }
```

in this way I obtained a list of tuples. The final step was simple because I only had to call toMap function.

Full code can be seen in this [REPO](https://github.com/ardeleanasm/bioinformatics).



