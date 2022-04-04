{
 :title "Monte Carlo Pi Estimation"
 :layout :post
 :tags [ "functional programming" ]
 :toc true}

In this post I'll show how Pi can be computed using a Monte Carlo algorithm in F#. Basically, using the idea of a dartboard we can obtain the value of PI by simply 
calculating the number of darts that land in the dartboard verses those that land outside it. And by increasing the number of throws we will get closer to PI's value, for example
throwing the dart 1000 times will be closer to PI than throwing the dart 10 or 100 times. 

The formula that we will use to determine PI by throwing darts is:

$$PI=4.0*\frac{hits}{darts thrown}$$

In our implementation in F# we will have 3 simple functions. We start by defining a function that will generate random numbers as 

```f#
let rnd=System.Random(System.DateTime.Now.Millisecond)

let genRandomNumbers (count:int) =
    List.init count (fun _ -> rnd.NextDouble ())
```
We initialize a System.Random object and we use it in `getRandomNumbers` to generate a value in interval [0,1]. The next thing we will have to do is to implement a 
function that will check if the thrown dart is in the dartboard or not. The function will have to return true if the distance between the coordinate of the dart and the center
of the circle is less than 1, otherwise false.

```f#
let isInside (x:double) (y:double)=(sqrt (x*x+y*y))<1.0
```

The third function is just a helper to check if the generated coordinate is inside the circle or not.

```f#
let sum (x:^a list)=
    match (isInside (x.Head*2.0-1.0) (x.Tail.Head*2.0-1.0)) with
        | false->0
        | true-> 1
```

Finally, we will implement a recursive function that computes PI. This function will take as arguments the number of throws, number of hits ( initially 0) and an 
index ( initially 0). If index value ( idx) reaches number of throws then we will return the value we calculated with the above formula. If not, then we will
recursively call the function with `hits+1` if the newly generated number is inside the circle and with `idx+1`.


```f#
let rec computePi (numThrows:int) (hits:int) (idx:int)=
    if numThrows=idx then
        4.0*((double)hits/(double)numThrows)
    else
          computePi numThrows (hits+(genRandomNumbers 2 |> sum)) (idx+1) 
```

And now, we can calculate PI:

```f#
[<EntryPoint>]
let main argv = 
    let l=computePi 1000000000 0 0
    printfn "%F" l
    0
```
