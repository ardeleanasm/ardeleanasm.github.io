---
layout: post
title: "Checksum generator in Haskell"
description: "Simple checksum generator in Haskell"
category: functional programming
tags: [ haskell ]
---

A few years ago I wrote a checksum generator app in C++ and evolved in, what I like to say, an app with password cracking capabilities. In fact, it was only an app that opened a file and calculated the hash for each line and tested with the target hash value. Simple!

<!--more-->

Simple and badly written. I even remove it because I remember that it was "OOP-like" written with a lot of duplicated code, implementations in .h file and so on. A collection of bad practices! It was working but, as I like to say, it was a miracle. :) I'm ashamed of that code and I hope that it cannot be found! 

Anyway, since I started to work with Haskell a lot, I thought that I should rewrite that app. So, Hasher was implemented. It's a command line tool that can work in interactive mode or by passing the options as command line arguments and can calculate MD5, SHA-1, SHA-256, SHA-512 hashes.

Hasher is implemented in three modules:

1. **Main**-> contains functions for printing help, app name and version and also contains the implementation of the interactive menu.
2. **HashGenerator**-> is a layer over cryptonite package.
3. **CommandLineParser** -> contains the implementation of command line arguments parsing.

From the point of view of dependencies, as it can be seen in cabal file, the build depends on the following packages:

* bytestring
* cryptonite
* text
* directory

From the point of view of usage, as I said, it has implemented two modes, interactive and command line options.

### Interactive Mode Example

```
$./hasher
  _    _           _               
 | |  | |         | |              
 | |__| | __ _ ___| |__   ___ _ __ 
 |  __  |/ _` / __| '_ \ / _ \ '__|
 | |  | | (_| \__ \ | | |  __/ |   
 |_|  |_|\__,_|___/_| |_|\___|_|   
Available Hash Functions:
	1. MD5
	2. SHA1
	3. SHA256
	4. SHA512
Select Hash Function:1
1. Hash plaintext
2. Hash File
1
Enter Plaintext:This is a test
"ce114e4501d2f4e2dcea3e17b546f339"
1. Continue
2. Exit
2
```
### Command Line Mode Example

```
$ ./hasher -h
  _    _           _               
 | |  | |         | |              
 | |__| | __ _ ___| |__   ___ _ __ 
 |  __  |/ _` / __| '_ \ / _ \ '__|
 | |  | | (_| \__ \ | | |  __/ |   
 |_|  |_|\__,_|___/_| |_|\___|_|   
hasher-exe <parameter> [<value>]
parameters:
		-h/--help	 help
		-v		 version
		-i		 interactive
		-f <option> <file>
		-s <option> <plaintext>
	_________________________________________________________
	|	Implemented Hash Functions	|	Option	|
	|		 MD5 			|	MD5	|
	|		 SHA1 			|	SHA1	|
	|		 SHA256 		|	SHA256	|
	|		 SHA512 		|	SHA512	|
	---------------------------------------------------------

$./hasher -s MD5 "This is a test"
  _    _           _               
 | |  | |         | |              
 | |__| | __ _ ___| |__   ___ _ __ 
 |  __  |/ _` / __| '_ \ / _ \ '__|
 | |  | | (_| \__ \ | | |  __/ |   
 |_|  |_|\__,_|___/_| |_|\___|_|   
"ce114e4501d2f4e2dcea3e17b546f339"

```

If you want to test Hasher, you want to fill an issue or you want to contribute, you can find Hasher's source code in this [REPO]. 

### Usage

* Clone or download repository
* stack init 
* stack build


[REPO]: https://github.com/ardeleanasm/hasher