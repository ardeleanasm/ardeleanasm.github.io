---
layout: blog/post
title: "Fractals Generator in Haskell"
description: "Fractal generation in Haskell"
category: functional programming
tags: haskell, functional programming, fractals
---

### Introduction

In this post I'll shortly describe some functions from a fractals generator that I wrote in Haskell. Some parts of the application are from the repository mentioned in this [post][1]. Some modules, like `Plots`, are reused from that module since I don't have experience with working with images in Haskell.
Currently there are not so much differences between the original repository and what I pushed into [my repository][2] but I hope that, in future, after I implement my ideas, the code will look more different. 

Regarding the ideas that I have and the fractals generator, maybe this post will start a short series of posts regarding this topic. First of all I want to have a generator that will use threads to draw parts of the fractal, to implement some command line arguments and to switch between a mode that will only save the drawing of a specified fractal and a mode that will permit also zooming.

### Implementation

First of all, let's start with a colors' palette. For this project I will start by generating a palette of 4096 colors. 

```haskell
colorPalette::[[Int]]
colorPalette = [[r,g,b] | r<-[0,16..255],g<-[0,16..255],b<-[0,16..255]]
```

Basically I organize the data as a list of lists. Each inner list contains three values corresponding to RGB. Function `getColor` defined below returns the selected color based on the current iteration.

```haskell
getColor::Int -> Color
getColor x
    | x > maxNumberOfIterations = rgb 255 255 255
    | otherwise = let c = colorPalette !! x
                in rgb (c !! 0) (c !! 1) (c !! 2)
```

Regarding the actual fractal generation, I will present only the function for drawing the Mandelbrot fractal.

```haskell
mandelbrot::Complex Double
    -> Complex Double
    -> Int
    -> Int
mandelbrot z c iter
    | iter > maxNumberOfIterations = 0
    | otherwise = let zNext = z^2 + c in
                if magnitude zNext > 2
                then iter
                else mandelbrot zNext c (iter+1)
```
Without getting too much into details, this function has 3 parameters, `z`, `c` and `iter`, of `Complex Double` and `Int` types and returns an `Int` value. From implementation point of view, if current iteration is greater than the maximum allowed number of iterations, then the function returns 0, otherwise, it will calculate `zNext`.

### Conclusions

No words, only pictures!

![Julia Fractal][img_julia]

![Julia Fractal][img_julia2]

![Mandelbrot Fractal][img_mandelbrot]

![Burning Ship Fractal][img_ship]

### Links

[Fractals in Haskell][1]
[Source Code Repository][2]

[img_julia]:../img/blog/julia.png "Julia fractal"
[img_julia2]:../img/blog/julia2.png "Julia fractal"
[img_mandelbrot]:../img/blog/mandelbrot.png "Mandelbrot fractal"
[img_ship]:../img/blog/ship.png "Burning Ship fractal"

[1]: https://gregheartsfield.com/fractal-hs/

[2]: https://github.com/ardeleanasm/project-fractals
