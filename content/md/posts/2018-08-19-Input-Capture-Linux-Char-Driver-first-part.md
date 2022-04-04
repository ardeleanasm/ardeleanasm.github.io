{
 :title "Input Capture Linux Char Driver - I part"
 :layout :post
 :tags [ "linux","drivers" ]
 :toc true}


## Introduction

To the best of my knowledge, on Linux there is no way to configure a hardware timer in input capture mode although, since it can be used on embedded systems, this feature can be needed. For example, if one needs to measure the period of a signal on a development board running a Linux distro he has no other way than sampling the GPIOs in userspace with the cost of a resolution of milliseconds.
<!--more-->

## Input Capture

Considering a rectangular signal like in Figure 1 and one want to measure the period of the signal or the pulse width. Basically, to measure the period of the signal two successive edges of the same polarity are captured and to measure the pulse width, two alternate polarity edges are captured. 

![Figure 1:Rectangular Signal][signal_plot]

For example, if one wants to measure the high time of a pulse it is enough to subtract the time captured when the rissing edge occurs from the time captured for the subsequent falling edge. This scenario can be easily implemented on a microcontroller using a hardware timer in input capture mode and I won't get into details.

But if one only have a development board with a Linux based OS it's hard to implement this task. The only option I can imagine is to use the GPIOs with rising and falling edges events enabled and to poll them. Of course, the obtained samples will be horrible and the resolution in milliseconds range. Or it'll be almost impossible. 

The options to "hack" the timers are excluded. Personally, I wanted to do that and I didn't found a proof that worked for someone. And also I didn't found any APIs, libraries to select a timer and put it into input capture mode. Of course, I didn't allocate much time for that task but the idea is that I couldn't found and maybe there isn't something like that. 

One can say that another option is to use a microcontroller and program it to perform the task of measuring the signal and to communicate with the development board via I2C, for example. Yes, it is possible but sometimes you don't have a microcontroller to use only for this small task. 

## Linux Char Driver

The solution described in this post: implementing a char driver. 

**Requirements**:

1. Service the interrupt thrown when rising, falling or both are detected on a GPIO.

2. Sample a timer to get the timestamp.

3. Detection of rising, falling or both must be configurable.

4. GPIO pin used must be configurable.

5. Notify userspace that a new value was read.

In this article I won't describe how to create a character driver for Linux, there are a lot of articles, quite nice described but somehow incomplete, on Web and also some very good books. In a future post I will shortly describe how the driver was implemented and also the needed device tree file to test it on a Beaglebone Black device.

Basically the third, fourth and fifth requirements are the easiest to implement. Basically, we need to define a variable of type **file_operations** structure and to implement some basic functions like: open, release, read, ioctl and poll. It will be discussed in future article the implementation and the need for those functions. 

To implement the first requirement a interrupt will be required and registered for the GPIO pin. The registers will be configured such that the interrupt will be thrown when the event will be detected. 

Finally, the second requirement is somehow problematic. The simple solution is to use **get_cycles()** function which will return the number of clock cycles but on ARM microprocessors this function returns 0. So, guards should be used to call **get_cycles()** when the driver is not running on ARM microprocessor and to call another function for getting a timestamp when running on ARM. 


## Conclusions

The implementation of the driver was quite easy after deciding what features should be implemented and after experimenting a few with *rw locks*, *tasklets* and so on. The most challenging part was debugging since for this driver I used only **printk-technique**, basically I printed logs for where I considered to be the problem. A step-by-step debugger, even on assembly code, would be much more appreciated.

[signal_plot]: /img/pwm_signal.jpg "Rectangular Signal"
