---
layout: blog/post
title: "Quantum Computing in Haskell - IV part"
description: "Quantum Computing with Haskell"
category: quantum computing
tags: [ haskell ]
---

## Articles

* [Quantum Computing in Haskell - I part][first_article]
* [Quantum Computing in Haskell - II part][second_article]
* [Quantum Computing in Haskell - III part][third_article]
* [Quantum Computing in Haskell - IV part][fourth_article]
* [Github Repository][git_repo]
* [Project's Haddock Documentation][documentation]
* [QChas Package][package]


## Introduction

In the previous articles, first three parts, I presented some haskell code to implement basic operators for simulating Quantum Algorithms. The full source code can be downloaded from [Github Repository][1]. The library was also published on [Hackage][2] and also on [Stackage][3] and is available with 2 versions, 1.0.0 and 1.0.1.0. Starting from version 1.0.1.0 the **Utils** module was removed and also, a new module for performing measurements was added. These articles will be also used as documentation/ wiki for the library.

In this fourth part we will start to present some Quantum Algorithms and we will start with one of the simplest ones, Deutsch's algorithm. In the next articles from the serie we will talk about Deutsch-Jozsa's algorithm, Grover's and Shor.

## Background

As I said in a previous article when I implemented this algorithm in Java, the problem that Deutsch's algorithm solves is not an important one in Computer Science but it's a good example to see the power of quantum computers, being solved by a quantum computer faster than by a traditional one, although not exponentially faster.

So, let's suppose that we have a function f with 1-bit input and 1-bit output. There are four possible functions, two of them are constant and two are balanced, as we can see in the table below.

<table style="border:1px solid black;">
  <tr>
    <th style="border:1px solid black;">Function</th>
    <th style="border:1px solid black;">Type</th> 
  </tr>
  <tr>
    <td style="border:1px solid black;">f<sub>1</sub>(0)=0<br> f<sub>1</sub>(1)=0</td>
    <td style="border:1px solid black;">constant</td> 
  </tr>
  <tr>
    <td style="border:1px solid black;">f<sub>2</sub>(0)=1<br> f<sub>2</sub>(1)=1  </td>
    <td style="border:1px solid black;">constant</td> 
  </tr>
  <tr>
    <td style="border:1px solid black;">f<sub>3</sub>(0)=0<br> f<sub>3</sub>(1)=1</td>
    <td style="border:1px solid black;">balanced</td> 
  </tr>
  <tr>
    <td style="border:1px solid black;">f<sub>4</sub>(0)=1<br> f<sub>4</sub>(1)=0</td>
    <td style="border:1px solid black;">balanced</td> 
  </tr>
</table>

The goal is to determine whether the function is constant or not. Let's say that we implement such a function on a classic computer:

```haskell
main::IO ()
main=do
  print $ testFunction f1
  print $ testFunction f2
  print $ testFunction f3
  print $ testFunction f4

f1::Int->Int
f1 val=0

f2::Int->Int
f2 val=1

f3::Int->Int
f3 val=val

f4::Int->Int
f4 val
  | val==0 = 1
  | val==1 = 0

testFunction::(Int->Int)->String
testFunction f
  |f 0 == f 1= "Constant"
  |otherwise= "Balanced"
```
and the output will be:

```
"Constant"
"Constant"
"Balanced"
"Balanced"
```

It can be easily seen that to check if a function is constant or balanced on a classical computer we need two calls to that function, basically we evaluate the function twice. We will see next that by using Deutsch's algorithm the problem can be solved by evaluating the function only once.

![The quantum circuit of Deutsch’s algorithm[1]][4]

The quantum circuit that we will have to implement can be seen in the picture above and basically we will have to:

* Apply **X-Gate** on the second qubit
* Apply $$H^2$$ gate, the Kronecker product between two **Hadamard** Gates
* Apply the gate ( or "oracle") $$U_f$$
* Apply Hadamard Gate again on the first qubit
* Measure the circuit

## Implementation

First of all, let's define the unitary transformations for all four functions:

```haskell
--f(0)=0 and f(1)=0
f1::Gate
f1=Gate ((4><4) [1,0,0,0
                ,0,1,0,0
                ,0,0,1,0
                ,0,0,0,1]::Matrix C)
--f(0)=1 and f(1)=1
f2::Gate
f2=Gate ((4><4) [0,1,0,0
                ,1,0,0,0
                ,0,0,0,1
                ,0,0,1,0]::Matrix C)
--f(0)=0 and f(1)=1
f3::Gate
f3=Gate ((4><4) [1,0,0,0
                ,0,1,0,0
                ,0,0,0,1
                ,0,0,1,0]::Matrix C)
--f(0)=1 and f(1)=0
f4::Gate
f4=Gate ((4><4) [0,1,0,0
                ,1,0,0,0
                ,0,0,1,0
                ,0,0,0,1]::Matrix C)                
```

The next step is to define a function that will test all the four functions:

```haskell
testDeutschsAlgorithm::IO()
testDeutschsAlgorithm=mapM_ deutsch [f1,f2,f3,f4]
```

Now, let's implement the algorithm:

```haskell

deutsch::Gate->IO()
deutsch oracle=do let (result:_)=measure circuit
                  case result of
                    '0' -> putStrLn "Function is constant"
                    '1' -> putStrLn "Function is balanced"
                    _   -> return()
    where
        gateHadamardOnTwoQubits=(hGate <+> hGate)
        circuit=entangle qZero (qZero |> xGate) |> gateHadamardOnTwoQubits |> oracle |> gateHadamardOnTwoQubits
        measure q=let result=map(\c->round (realPart (c * conjugate c))) (toList . flatten $ qubitState q)        
                  in case result of
                    [0,1,0,0]->"01"
                    [0,0,0,1]->"11"
                    _        ->"??"
```

If we run the code we will have:

```
ghci>testDeutschsAlgorithm
Function is constant
Function is constant
Function is balanced
Function is balanced

```

## Conclusions

As we can see in this first example, running an algorithm, even a simple one, on a quantum computer can be faster than running it on a classical computer. 

About the implemented library, as I said, you can download it from the links that I specified before and these articles and examples of code will be used as a "How to use.." for the library. 

[first_article]: https://ardeleanasm.github.io/Quantum-Computing-in-Haskell/
[second_article]: https://ardeleanasm.github.io/Quantum-Computing-in-Haskell-second-part/
[third_article]: https://ardeleanasm.github.io/Quantum-Computing-in-Haskell-third-part/
[fourth_article]: https://ardeleanasm.github.io/Quantum-Computing-in-Haskell-fourth-part/
[git_repo]: https://github.com/ardeleanasm/qchas
[documentation]: https://ardeleanasm.github.io/qchas/
[package]: https://hackage.haskell.org/package/qchas

[1]: https://github.com/ardeleanasm/qchas
[2]: https://hackage.haskell.org/package/qchas
[3]: https://www.stackage.org/nightly-2017-08-17/package/qchas-1.0.1.0
[4]: http://ardeleanasm.github.io/resources/deutsch_quantum_circuits.png