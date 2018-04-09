---
layout: post
title: "Deutsch's Algorithm"
description: ""
category: quantum computing
tags: java
---

In this post I'll present a quantum implementation of the Deutsch's algorithm using a library **QuantumComputingLib** that I wrote this week. 

First, I should write a little about the library. It's version *1.0-SNAPSHOT* only and it doesn't have an official release version. 
For now, it only has a basic Javadoc and only provides methods for well-known operations on qubits and matrices. 
I hope that I will able to offer support for it and that this project will be active for a long time, I hope that at least 2 years. 
If someone want to use and test the library, it can be found at the next [link](https://github.com/ardeleanasm/quantum_computing/tree/master/quantum).
Also, for using this algorithm, you'll need the **ComplexNumber** library. 
This library can be found at the next [link](https://github.com/ardeleanasm/projects/tree/master/complexnumbers).

### Deutsch's algorithm


The problem that Deutsch's algorithm solves is not an important problem in Computer Science but it's a good problem
to see how quantum computers can be used. This problem can be solved by a quantum computer faster that a traditional one, althoug not exponentially faster.

Suppose there is a function f, which has 1-bit inputs/outputs. The maximum number of such function is four:

| Function                 | Type     |
|:-------------------------|:--------:|
| $f_{1}(0)=0, f_{1}(1)=0$ | constant |
| $f_{2}(0)=1, f_{2}(1)=1$ | constant |
| $f_{3}(0)=0, f_{3}(1)=1$ | balanced |
| $f_{4}(0)=1, f_{4}(1)=0$ | balanced |


The goal was to determine whether the function passed to an algorithm's input is constant or not. 
Using a traditional computing this problem can be solved only by evaluating the function twice but using a quantum one, 
the type of the function can be determined by evaluating it once. 


### Implementation


![The quantum circuit of Deutsch’s algorithm[1]](http://ardeleanasm.github.io/resources/deutsch_quantum_circuits.png)


```java
gateH = gateFactory.getGate(EGateTypes.E_HadamardGate);
gateX = gateFactory.getGate(EGateTypes.E_XGate);
gateHH = MatrixOperations.tensorProduct(gateH.getUnitaryMatrix(), gateH.getUnitaryMatrix());
```


```java
resultQubit = QuantumOperations.applyGate(QuantumOperations.applyGate(
			    QuantumOperations.applyGate(
				    QuantumOperations.entangle(QUBIT_0, QuantumOperations.applyGate(QUBIT_0, gateX)), gateHH),
			    functionOperator), gateHH);
```

* Apply the X-Gate on the second qubit.
* Determine the tensor product between the 2 qubits.
* Calculate the tensor product between the two Hadamard gates and apply the resulting gate.
* Apply U<sub>f</sub> operator.
* Apply again the Hadamard gate.

---
References:

[1] [http://kukuruku.co/hub/haskell/how-to-implement-deutschs-algorithm-in-haskell](http://kukuruku.co/hub/haskell/how-to-implement-deutschs-algorithm-in-haskell)

[2] [http://www.cs.xu.edu/~kinne/quantum/deutche.html](http://www.cs.xu.edu/~kinne/quantum/deutche.html)