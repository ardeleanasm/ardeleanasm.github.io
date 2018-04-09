---
layout: post
title: "Quantum Computing in Haskell - I part"
description: "Quantum Computing intro with Haskell"
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

## Long story made short

1 year ago I started studying the topics of Quantum Computing and Quantum Algorithms and I was fascinated. Is interresting and, like Niels Bohr said, "Anyone who is not shocked by quantum theory has not understood it." 

As doing my research I found quite interesting to post some small articles on these topics, some articles on CodeProject ([Java based Quantum Computing Library][2] and [Grover's Search Algorithm Explained][3]) and one on my website about [Deutsch's algorithm][1]. For those articles I used a Java library that I created myself with the help of some of my colleagues. Now, after a year and after playing a little with Haskell, I found quite interesting to review the topic and to start posting a series of small articles about Quantum Computing. 

## Introduction

I'll start by talking a little about the difference between a quantum computer and a traditional one. A lot of information about how a quantum computer works can be found in online courses, research papers and books. It's not the scope of this post to explain in details how it works, just to present some basic differences. 

As someone can expect, a quantum computer use the quantum mechanical effects, such as superposition, to carry out computations. We already know that in a traditional computer, the **bit** is the basic unit and it can be 0 or 1. The value is defined by a voltage level, in TTL technology, ideally, a 1 value is represented by 5.00 volts while a 0 value is represented by 0.00 volts. For a quantum computer, there are some differences. For example, the basic unit is the **qubit** (quantum bit) and can, at one time, represent value 0 and 1, by exploiting superposition. A qubit is defined by the equation presented below:

$\newcommand{\ket}[1]{\left|{#1}\right\rangle}$
$\newcommand{\bra}[1]{\left\langle{#1}\right|}$
$\ket{v}=\alpha\ket{0}+\beta\ket{1}$


Before diving deeper into the subject, we will firstly review some mathematical aspects of the topic. 

## Complex Numbers   

Since probability amplitudes of a qubit are complex numbers I prefer to start with a very short introduction in the mathematics of complex numbers. 

A complex number q is defined as $q=a+bi$ where a and b $\in \mathcal{R}$ and $i=\sqrt{-1}$ is the imaginary basis unit. 

We can see that **a** is the real component of a complex number and **bi** is the imaginary one. We can obtain the complex conjugate by simply negating the sign of the imaginary component $\overline{q}=a-bi$.

Some basic formulas that we will use during this series of articles will be addition, multiplication, and modulus.

Let's consider 2 complex numbers x and y defined like:

$$x=a+bi$$ 

and 

$$y=c+di$$

The addition of these 2 complex numbers is defined by:

$$z=x+y=a+bi+c+di=a+c+i(b+d)$$

while multiplication is defined by:

$$z=x*y=(a+bi)(c+di)=ac-bd+i(ad+cb)$$

The third operation, the modulus of the complex number x is defined by:

$$|x|=\sqrt{a^2+b^2}$$

## Vectors

While Complex Numbers are used to represent the probability amplitudes of a qubit, vectors and linear algebra helps us to represent qubits, so I decided that it'll be usefull to present some notations and operations before starting to write code.

Basically, the state of a qubit is a unit vector in a 2-dimensional complex vector space $\mathcal{C}^2$.

The vector $$\begin{bmatrix}\alpha\\ \beta\end{bmatrix}$$ can be written as


$$\alpha\ket{0}+\beta\ket{1}$$

where

$$\ket{0}=\begin{bmatrix}1\\0\end{bmatrix}$$

and

$$\ket{1}=\begin{bmatrix}0\\1\end{bmatrix}$$

In the above example I used the **bra-ket** notation, the notation of a column vector is called **ket** while the notation of a row vector is called **bra**. Next, I will define 3 basic operations that will be used heavily in the examples from the next articles on this topic, the inner product, outer product and tensor product.


The inner product, $\bra{v}\ket{v}$ is the product between the bra and the ket vectors:

$$\bra{v}\ket{v}=\begin{pmatrix}{c_1}^* & {c_2}^* \end{pmatrix}\begin{pmatrix}{c_1} \\ {c_2} \end{pmatrix}={c_1}^*{c_1}+{c_2}^*{c_2}={|c_1|}^2+{|c_2|}^2$$


Outer product is **ket-bra** and is given by:

$$\ket{v}\bra{v}=\begin{pmatrix}c_1 \\ c_2 \end{pmatrix}\begin{pmatrix}{c_1}^* & {c_2}^*\end{pmatrix}=\begin{pmatrix} c_1{c_1}^* & c_1{c_2}^* \\ c_2{c_1}^* & c_2{c_2}^* \end{pmatrix}$$


Lastly, if we consider $$\ket{v}=\begin{pmatrix}{c_1} \\ {c_2} \end{pmatrix}$$ and
$$\ket{x}=\begin{pmatrix}{c_3} \\ {c_4} \end{pmatrix}$$ we can define the tensor product as:

$$\ket{v}\otimes\ket{x}=\ket{vx}=\begin{pmatrix}{c_1}{c_3} \\ {c_2}{c_3} \\ {c_1}{c_4} \\ {c_2}{c_4} \end{pmatrix}$$


## Qubits and Gates

Quantum mechanics tells that any such system can exist in a superposition of states and as we saw in the second chapter, the state of a qubit is described by 

$$\ket{v}=\alpha\ket{0}+\beta\ket{1}$$ 

where $\alpha$ and $\beta$ are complex number that satisfy the relation 

$${|\alpha|}^2+{|\beta|}^2=1$$

We know that on a classic computer gate operations such as **AND**, **OR**,**XOR** constitute the core of data manipulation. On a quantum computer similar operations are possible on qubits by using quantum gates. The gate operations are exactly all unitary linear operations. 

For example, the Hadamard transformation is defined as:

$$\alpha\ket{0}+\beta\ket{1}\rightarrow\frac{\alpha+\beta}{\sqrt{2}}\ket{0}+\frac{\alpha-\beta}{\sqrt{2}}\ket{1}$$

Knowing that $$\ket{0}=\begin{bmatrix}{1} \\ {0} \end{bmatrix}$$ and $$\ket{1}=\begin{bmatrix}{0} \\ {1} \end{bmatrix}$$ then we can represent the transformation as the matrix:

$$\frac{1}{\sqrt{2}}\begin{pmatrix}1 & 1 \\ 1 & -1 \end{pmatrix}$$

A Hadamard gate creates a superposition state, often beginning and ending a quantum computation to initiate data processing and to collect data, respectively.

A set of useful 1-qubit gates are the Pauli Gates, the X gate, Y gate and Z gate.

$$X\ket{0}=\ket{1} and X\ket{1}=\ket{1}; X=\begin{pmatrix}0 & 1 \\ 1 & 0 \end{pmatrix}$$

$$Y\ket{0}=i\ket{1} and Y\ket{1}=-i\ket{0}; Y=\begin{pmatrix}0 & -i \\ i & 0 \end{pmatrix}$$

$$Z\ket{0}=\ket{0} and Z\ket{1}=-\ket{1}; Z=\begin{pmatrix}1 & 0 \\ 0 & -1 \end{pmatrix}$$

Two more gates that we will use in our examples are the Controlled-Not and Controlled Phase Shift and they are defined by the following matrices:


$$Controlled Phase Shift=\begin{pmatrix} 1 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & -1\end{pmatrix}$$

$$Controlled Not=\begin{pmatrix} 1 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 1 \\ 0 & 0 & 1 & 0 \end{pmatrix}$$

In the next article we will write some code that implements some basic operations. 

[1]: https://ardeleanasm.github.io/deutschs-algorithm/
[2]: https://www.codeproject.com/Articles/1130092/Java-based-Quantum-Computing-library
[3]: https://www.codeproject.com/Articles/1131573/Grovers-Search-Algorithm-explained


[first_article]: https://ardeleanasm.github.io/Quantum-Computing-in-Haskell/
[second_article]: https://ardeleanasm.github.io/Quantum-Computing-in-Haskell-second-part/
[third_article]: https://ardeleanasm.github.io/Quantum-Computing-in-Haskell-third-part/
[fourth_article]: https://ardeleanasm.github.io/Quantum-Computing-in-Haskell-fourth-part/
[git_repo]: https://github.com/ardeleanasm/qchas
[documentation]: https://ardeleanasm.github.io/qchas/
[package]: https://hackage.haskell.org/package/qchas



