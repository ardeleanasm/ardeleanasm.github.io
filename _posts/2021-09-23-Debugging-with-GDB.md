---
layout: blog/post
title: "Debugging with GDB"
description: "Debugging with GDB"
category: Linux
tags: gdb
---


Some useful comands for debugging C/C++ applications using GDB from command line:

## Starting GDB:
1.  Attach to a running process: gdb -p `pidof running_process`
2. Start GDB attached to the application you want to debug: gdb application_name

## Step through code:
1. Start the execution by using run or start
2. Continue execution by using continue
3. Step through code with next for step over and with step for step into
4. Print value of the argument using print.

More resources are available [HERE](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/developer_guide/debugging-running-application)

