---
layout: blog/post
title: "Some recursive algorithms using C++ template metaprogramming"
description: "Some recursive algorithms using C++ template metaprogramming"
category: c++
tags: algorithms, c++, template metaprogramming
---

```C++
#include <iostream>
#include <cstdint>
```

## Fibonacci

```C++
template<std::uint64_t I>
struct Fib
{
    static constexpr std::uint64_t val = Fib<I-1>::val + Fib<I-2>::val;
};

template <>
struct Fib<0>
{
    static constexpr std::uint64_t val = 0;
};

template <>
struct Fib<1>
{
    static constexpr std::uint64_t val = 1;
};
```

## Factorial

```C++
template <std::uint64_t N>
struct Fact
{
    static constexpr std::uint64_t val = N * Fact<N-1>::val;
};

template<>
struct Fact<0>
{
    static constexpr std::uint64_t val = 1;
};
```

## Collatz conjecture

```C++
template <std::uint64_t, std::uint64_t, std::uint64_t> struct CollatzHelper;

template<std::uint64_t A, std::uint64_t B>
struct CollatzHelper<A,B,1>:public CollatzHelper<(A*3+1),B+1,((A*3+1)%2)>{};

template<std::uint64_t A, std::uint64_t B>
struct CollatzHelper<A,B,0>:public CollatzHelper<(A/2),B+1,((A/2)%2)>{};


template <std::uint64_t B> struct CollatzHelper<1,B,1>
{
    static constexpr std::uint64_t conj = B;
};

template<std::uint64_t A> struct Collatz: public CollatzHelper<A,0,A%2>{};
```
