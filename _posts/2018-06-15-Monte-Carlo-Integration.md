---
layout: post
title: "Monte Carlo Integration"
description: "A Monte Carlo Integration algorithm implemented in OCaml"
category: functional programming
tags: OCaml
---

Monte Carlo methods are numerical techniques which rely on random
sampling to approximate their results. Thus, in Monte Carlo integration,
the process of numerical estimation of integrals is applied.
<!--more-->
Considering we want to integrate a one-dimensional function $f(x)$ from
$\textit{a}$ to $\textit{b}$: $$F=\int_a^b f(x)\,\mathrm{d}x$$. Since the integral of a function $f(x)$ can be
interpreted as the area below the function's curve, we can pick up a random value $x \in [a,b]$ and evaluate the function at $\textit{x}$ and multiply the result by $(b-a)$. If we plot the function's curve and the result we will obtain a rectangle where *f(x)* is the height and *(b-a)* is the width, basically a crude approximation of the area under the curve. If we continue to evaluate the function at different random points between *a* and *b*, adding up the area of the rectangles and averaging the sum, the resulting number gets closer to the actual results of the integral.

Let's consider an example in which the function we want to integrate is $f(x)=\sin{x}$ on interval $[0,\pi]$ and write some **OCaml** code. The function plot can be seen in Fig. 1.

![Fig. 1:sin(x) curve][1]

We will create a new module **MonteCarlo** with the interface defined in the below snippet:
```ocaml
module type MonteCarlo_type=sig
  val initializePRNG:unit->unit
  val getRandomNumber:unit->float
  val approximate:(float->float)->float->float->int->int->float->float  
end
```

We have a function *initializePRNG* which will initialize the pseudorandom number generator, `let initializePRNG ()=Random.self_init()`. `let getRandomNumber ()=Random.float 1.0` function will only generate a pseudorandom number distributed on $[0,1]$. Finally, the most interesting function, *approximate* receives 6 parameters as follow:
*. First parameter is the function $f(x)$
*. Second and third parameters are the limits *a* and *b*.
*. Fourth parameter is the number of iterations.
*. Fifth parameter is the current iteration
*. Sixth parameter is the sumed value.

```ocaml
let rec approximate f a b n index value=
    if index=(n-1) then
      ((b-.a)/.(float_of_int index))*.value
    else
      let randVal=getRandomNumber() in
      let inInterval=a+.randVal*.(b-.a) in
      let fVal=f inInterval in
      approximate f a b n (index+1) (value+.fVal)

```
The complete *MonteCarlo* module is implemented bellow:

```ocaml
open Random
open MonteCarlo_type

module MonteCarlo:MonteCarlo_type=struct
  let initializePRNG ()=Random.self_init()
  let getRandomNumber ()=Random.float 1.0
  
  let rec approximate f a b n index value=
    if index=(n-1) then
      ((b-.a)/.(float_of_int index))*.value
    else
      let randVal=getRandomNumber() in
      let inInterval=a+.randVal*.(b-.a) in
      let fVal=f inInterval in
      approximate f a b n (index+1) (value+.fVal)
end
```

Finally, to use the code we just need to define the function that we want to integrate and call approximate, as bellow:

```ocaml
open MonteCarlo

let pi = 4.0 *. atan 1.0;;
let func (x:float)=sin x
let () = 
  MonteCarlo.initializePRNG();
  print_float (MonteCarlo.approximate func 0.0 pi 100000 0 0.0)

```



[1]: ../resources/integration-sinx-curve.png
