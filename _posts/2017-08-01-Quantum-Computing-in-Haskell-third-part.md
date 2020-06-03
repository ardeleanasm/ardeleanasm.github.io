---
layout: blog/post
title: "Quantum Computing in Haskell - III part"
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

In the second part of this series I talked about the Haskell implementation of Qubits. There are two more articles about the library and after that I will start posting about algorithms. In this article we will define some Quantum Gates that we will use in our algorithms, even if in the first article I wrote a little about this topic and I presented some matrices.

## Background

As we already know computers are built using logic gates and in a similar way quantum computation also use logic gates that can be designed by considering unitary transformation of the qubits. In conclusion, we can construct infinitely many quantum logic gates with the constraint that they must be reversible.

In the first article from this series I already presented some gates but we didn't see their symbol or truth table.

### 1 qubit gates

#### Pauli X-Gate or NOT gate

*Symbol:*

![X-Gate Symbol][xgate_img]

*Matrix:*

$$X=\begin{pmatrix}0 & 1 \\ 1 & 0 \end{pmatrix}$$

*Transformation:*

$$\newcommand{\ket}[1]{\left|{#1}\right\rangle}$$
$$\newcommand{\bra}[1]{\left\langle{#1}\right|}$$
$$X\ket{0}=\ket{1}, X\ket{1}=\ket{0}$$

#### Pauli Y-Gate

*Symbol:*

![Y-Gate Symbol][ygate_img]

*Matrix:*

$$Y=\begin{pmatrix}0 & -i \\ i & 0 \end{pmatrix}$$

*Transformation:*

$$Y\ket{0}=i\ket{1}, Y\ket{1}=-i\ket{0}$$

#### Pauli Z-Gate

*Symbol:*

![Z-Gate Symbol][zgate_img]

*Matrix:*

$$Z=\begin{pmatrix}1 & 0 \\ 0 & -1 \end{pmatrix}$$

*Transformation:*

$$Z\ket{0}=\ket{0} and Z\ket{1}=-\ket{1}$$

#### Hadamard Gate:

*Symbol:*

![H-Gate Symbol][hgate_img]

*Matrix:*

$$H=\frac{1}{\sqrt{2}}\begin{pmatrix}1 & 1 \\ 1 & -1 \end{pmatrix}$$

*Transformation:*

$$H\ket{0}=\frac{1}{\sqrt{2}}(\ket{0}+\ket{1}), H\ket{1}=\frac{1}{\sqrt{2}}(\ket{0}-\ket{1})$$

### Controlled Quantum Gates

Controlled Quantum Gates are useful for implementing **IF-THEN-ELSE** type operations. In this article we will only present **CNOT**.

#### Controlled-NOT (CNOT)

*Symbol:*

![CNOT-Gate Symbol][cnotgate_img]

*Truth Table:*

| x | y | x $$(x\oplus y)$$ |
|:-:|:-:|:---------------:|
| 0 | 0 | 0 0             | 
| 0 | 1 | 0 1             |
| 1 | 0 | 1 1             |
| 1 | 1 | 1 0             |

## Implementation

Having the background now, let's start implementing those gates in Haskell. First, let's define a new data named **Gate**.

```haskell
data Gate=
  Gate {
          gateMatrix::(Matrix C) 
        } deriving (Eq,Show)
```

Our data **Gate** has a constructor **Gate** with one parameter, **gateMatrix**, of type ** complex matrx**, `Matrix C`. Let's see the code in **GHCI**:

```
ghci>:t Gate
Gate :: Matrix C -> Gate
ghci>let g= Gate ((2><2) [1,0,0,-1]::Matrix C)
ghci>g
Gate {gateMatrix = (2><2)
 [ 1.0 :+ 0.0,       0.0 :+ 0.0
 , 0.0 :+ 0.0, (-1.0) :+ (-0.0) ]}
ghci>>gateMatrix g
(2><2)
 [ 1.0 :+ 0.0,       0.0 :+ 0.0
 , 0.0 :+ 0.0, (-1.0) :+ (-0.0) ]
 ```

In the above example we created a Pauli Z-Gate. We will proceed like for Qubit and we will define some functions that will return a Gate. We will implement the Pauli X-Gate, Y-Gate, Z-Gate, Hadamard Gate, CNOT-Gate, and Controlled Phase Shift Gate ( we will need in Grover's Algorithm).

```haskell
xGate::Gate
xGate=Gate ((2><2)[0,1,1,0]::Matrix C)

yGate::Gate
yGate=Gate ((2><2) [0.0,0.0:+(-1.0),0.0:+1.0,0.0]::Matrix C)

zGate::Gate
zGate=Gate ((2><2) [1,0,0,-1]::Matrix C)

hGate::Gate
hGate=Gate ((2><2) [1/sqrt 2,1/sqrt 2,1/sqrt 2,(-1)/sqrt 2]::Matrix C)

cNotGate::Gate
cNotGate=Gate ((4><4)[1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0]::Matrix C)

cPhaseShifGate::Gate
cPhaseShifGate=Gate ((4><4)[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,-1]::Matrix C)
```

Now, in GHCI, if we call, for example `zGate` we will see that the output is the same with the one from the previous example:

```
ghci>zGate
Gate {gateMatrix = (2><2)
 [ 1.0 :+ 0.0,       0.0 :+ 0.0
 , 0.0 :+ 0.0, (-1.0) :+ (-0.0) ]}
ghci>:t zGate
zGate :: Gate
```

## Conclusions

In this article we implemented some 1-qubit Gates and some Controlled-Gate. In next articles we will define some functions to apply those gate on qubits and also to create gates, starting from 1-qubit ones, that apply on multiple qubits. New ideas, features, issues are welcomed and I encourage every reader to submit them on Github or ask questions using Disquss.

[first_article]: ../Quantum-Computing-in-Haskell/
[second_article]: ../Quantum-Computing-in-Haskell-second-part/
[third_article]: ../Quantum-Computing-in-Haskell-third-part/
[fourth_article]: ../Quantum-Computing-in-Haskell-fourth-part/
[git_repo]: https://github.com/ardeleanasm/qchas
[documentation]: https://ardeleanasm.github.io/qchas/
[package]: https://hackage.haskell.org/package/qchas

[1]: https://hackage.haskell.org/package/hmatrix
[2]: https://github.com/ardeleanasm/quantum_computing


[xgate_img]: ../blog/resources/quantum_serie/xgate.png "Pauli XGate"
[ygate_img]: ../blog/resources/quantum_serie/ygate.png "Pauli YGate"
[zgate_img]: ../blog/resources/quantum_serie/zgate.png "Pauli ZGate"
[hgate_img]: ../blog/resources/quantum_serie/hgate.png "Hadamard Gate"
[cnotgate_img]: ../blog/resources/quantum_serie/cnotgate.png "Controlled-NOT"
