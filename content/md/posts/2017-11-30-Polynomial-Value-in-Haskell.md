{
 :title "Polynomial Value in Haskell"
 :layout :post
 :tags [ "haskell","functional programming" ]
 :toc true}


While working on a project that analyze some signals in Haskell I found that I need a simple function `polyVal` that evaluates a polynomial at specific values. 

After a failed search for this function ( I thought that I can find a library or an implementation) I decided to write it on my own, anyway, it's a simple function.

So, let's suppose we have a polynomial *p* of degree *N*, this function returns the value:

$$p_{0}*x^{N-1}+p_{1}*x^{N-2}+...+p_{N-2}*x+p_{N-1}$$

The Haskell implementation of this function is:

```haskell
evalPoly::Double->[Double]->Double
evalPoly n xs=sum $ map (\e->e*n**fromIntegral ((length xs)-1-(fromJust $ elemIndex e xs))) xs
```

Example of ussage:

```
>evalPoly 3 [-19,7,-4,6]
-456.0
>evalPoly 5 [3,0,1]
76.0
```

