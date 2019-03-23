---
layout: post
title: "Circuit Design and Simulation in Geda"
description: "Circuit Design and Simulation in Geda"
category: electronics
tags: geda, diode clipping circuit
---

This post won't be a tutorial on electronic circuits but will present a free method to desing and simulate electronic circuits on Linux using **Geda** and **ngspice**.
<!--more-->

To start, I will chose a simple diode clipping circuit which consist of the following elements:

1. 2 1N4007 diodes
   
2. 2 10K resistors

![Img 1:Diode clipping circuit on both half cycles][circuit_scheme]

The schematic is available in Img 1. Note that for this circuit is mandatory to have the *.mod* file for 1N4007 diode. 

Now, using the terminal run the following commands:

*  *gnetlist -g spice-sdb -o diode.net diode.sch* to generate the netlist
  
* *ngspice* to run ngspice
    * *source diode.net* to load the netlist
  
    * *tran .01ms .15ms* to perform transient analysis
  
    * *plot* to plot the signals.

For the above circuit, the plotted signals are presented in Img 2.


![Img 2:Diode clipping circuit plotted signals][plots]


[circuit_scheme]: ../images/Circuit-Design-and-Simulation-in-Geda-pic1.png "Img 1:Diode clipping circuit on both half cycles"

[plots]: ../images/Circuit-Design-and-Simulation-in-Geda-pic2.png "Img 2:Diode clipping circuit plotted signals"