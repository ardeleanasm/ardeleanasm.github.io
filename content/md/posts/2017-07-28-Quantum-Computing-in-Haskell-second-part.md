{
 :title "Quantum Computing in Haskell - II part"
 :layout :post
 :tags [ "haskell","quantum computing" ]
 :toc true}



## Articles

* [Quantum Computing in Haskell - I part][first_article]
* [Quantum Computing in Haskell - II part][second_article]
* [Quantum Computing in Haskell - III part][third_article]
* [Quantum Computing in Haskell - IV part][fourth_article]
* [Github Repository][git_repo]
* [Project's Haddock Documentation][documentation]
* [QChas Package][package]

## Introduction

In the first article from this series I presented some basic math and I suggest reading that article first if someone is not familiar with the topic of Quantum Computing. In this article, the second from the series I will present the implementation in Haskell. The plan is that after a few articles in which I will present the data types, modules, functions, we will implement some Quantum algorithms like Deutsch's Algorithm, Grover's Algorithm, Deutsch-Josza's Algorithm and maybe Shor's algorithm.

## Background

We saw in the previous article that the state of a qubit can be described by

$$\newcommand{\ket}[1]{\left|{#1}\right\rangle}$$
$$\newcommand{\bra}[1]{\left\langle{#1}\right|}$$
$$\ket{v}=\alpha\ket{0}+\beta\ket{1}$$

where

$${|\alpha|}^2+{|\beta|}^2=1$$

and 

$$\ket{0}=\begin{bmatrix} 1 \\ 0\end{bmatrix}$$
$$\ket{1}=\begin{bmatrix} 0 \\ 1\end{bmatrix}$$

It's clearly, from the above equations, that we have to implement a Qubit type and the qubits $$\ket{0}$$ and $$\ket{1}$$.

## Implementation

For the implementation in Haskell I chose to use [hmatrix][1] library because we will have to work with matrices and vectors and by using this library we won't have to implement new types and functions that performs the needed operations. 

Anyway, a simple solution that don't use hmatrix is to define our own **matrix** and **vector** types like 

```haskell
type Vector a=[a]
type Matrix a=[Vector a]
```

and also some functions that will create our complex vectors and matrices

```haskell
complexVector::Real a=>Vector a->Vector(Complex Double)
complexVector=map(\i->realToFrac i:+0.0)

complexMatrix::Real a=>Matrix a->Matrix(Complex Double)
complexMatrix=map complexVector
```
Since I don't think that is a feasible approach I won't discuss the above code. Is nice to know that we can implement it without using hmatrix, is another approach, even the first version of code from repository was implemented this way but it's a lot of work. I won't reinvent the wheel, at least for now! :)

Ok, first of all let's define a new data named **Qubit**.

```haskell
data Qubit=
    Qubit {
            qubitState::(Matrix C) 
          } deriving (Eq,Show)
```
Our data type has a constructor **Qubit** with one parameter, **qubitState**, of type **complex matrix**, `Matrix C`. If we load the above code in **GHCI** we can check the new type that we defined:

```
ghci> :t Qubit
Qubit :: Matrix C -> Qubit

```
We can see that Qubit is the data type and the constructors accepts an argument of type *Matrix C* and returns a *Qubit*. Ok, now let's try to create a Qubit.

```
ghci>let q=Qubit ((2><1)[1,0]::Matrix C)
ghci>q
Qubit {qubitState = (2><1)
 [ 1.0 :+ 0.0
 , 0.0 :+ 0.0 ]}
ghci>qubitState q
(2><1)
 [ 1.0 :+ 0.0
 , 0.0 :+ 0.0 ]
```

Basically, in the above example we created the $$\ket{0}$$. Since in our future examples we will use it a lot alongside $$\ket{1}$$ we should define some functions that will return them.

```haskell
qZero::Qubit
qZero=Qubit ((2><1)[1,0]::Matrix C)

qOne::Qubit
qOne=Qubit ((2><1) [0,1]::Matrix C)
```

One question that might arise after seeing the code is "Ok, why is Matrix type used instead of Vector?" The answer is quite simple, because we will have to implement, in the next articles, some operations with qubits and gates and is more simple to have the same type for both. Now, if we fire up GHCI and type:

```
ghci>>qZero
Qubit {qubitState = (2><1)
 [ 1.0 :+ 0.0
 , 0.0 :+ 0.0 ]}
ghci>>qOne
Qubit {qubitState = (2><1)
 [ 0.0 :+ 0.0
 , 1.0 :+ 0.0 ]}
```
we see that we have two functions that returns our needed qubits. 

After the experience that I have with [Java Library for Quantum Computing][2] I think that is useful to also define two more qubits, $$\ket{+}$$ and $$\ket{-}$$. Those qubits can be simply obtained by simply applying the Hadamard Gate on $$\ket{0}$$ and on $$\ket{1}$$ respectively.

```haskell
qPlus::Qubit
qPlus=Qubit ((2><1) [1/sqrt 2, 1/sqrt 2]::Matrix C)

qMinus::Qubit 
qMinus=Qubit ((2><1) [1/sqrt 2, -1/sqrt 2]::Matrix C)
```

## Conclusions

For now, we have defined a Qubit type and we can create any qubit. We also define some functions that will create the most used qubits. In future articles we will define a Gate type and we will also implement some operations. 

Based on my experience that I have on this topic after doing some research and implementing from scratch a library in Java I was surprised when I saw how fast I can implement this code in Haskell. It was quite simple and it took less time.

[first_article]: ../Quantum-Computing-in-Haskell/
[second_article]: ../Quantum-Computing-in-Haskell-second-part/
[third_article]: ../Quantum-Computing-in-Haskell-third-part/
[fourth_article]: ../Quantum-Computing-in-Haskell-fourth-part/
[git_repo]: https://github.com/ardeleanasm/qchas
[documentation]: https://ardeleanasm.github.io/qchas/
[package]: https://hackage.haskell.org/package/qchas

[1]: https://hackage.haskell.org/package/hmatrix
[2]: https://github.com/ardeleanasm/quantum_computing