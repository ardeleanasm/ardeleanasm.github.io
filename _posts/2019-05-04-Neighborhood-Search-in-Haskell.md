---
layout: post
title: "Neighborhood Search"
description: "Neighborhood Search implementation in Haskell"
category: functional programming
tags: haskell, functional programming, heuristic methods, neighborhood search
---

### Implementation


```haskell
import System.Random
import System.IO.Unsafe
import Control.Monad ( replicateM)
```

The first thing that should be done is to write some helper-functions for generating pseudorandom numbers. To do that, I'll start by defining **seed** for random generators and a function that will generate a finite length list of values in range, `getRandomValuesInRange::Int->Int->Int->IO [Int]`. For exercise purpose only, I'll define second function that will return a finite length list of doubles, uniformly distributed on $[0,1)$, `getRandomValues::Int->[Double]`.


```haskell
seed::Int
seed=(-958036805781772734)
```


```haskell
getRandomValues :: Int -> [Double]
getRandomValues len=take len $ randoms (mkStdGen seed)::[Double]
```


```haskell
getRandomValuesInRange::Int->Int->Int->IO [Int]
getRandomValuesInRange len a b = replicateM len (getStdRandom $ randomR (a,b))
```

Since `getRandomValuesInRange` returns a `IO` list of integers, I'll define a wrapper that will return a list of integers. The wrapper will abuse of `unsafe IO`. In a future implementation this wrapper will be removed and all operations will be performed safe.


```haskell
getRandomValueUnsafe::Int->Int->Int->[Int]
getRandomValueUnsafe len a b =unsafePerformIO $ getRandomValuesInRange len a b
```

Now, I need to define the characteristics of an item. In case of knapsack problem, each item has a **weight** and a **value**. Considering this, I'll define a new type **Item** which will be a tuple of weight and value. To be mentioned that instead of using `newtype` I could use `type`. The reason behind not choosing `type` is that I don't want to tightly couple the implementation with the problem.


```haskell
newtype Item = Item { rawItem::(Int,Int) } deriving (Show,Eq)
```

Next step is to define a generic datatype for the possible solutions. For a simple problem like knapsack the solution can be a list of binary values.


```haskell
newtype Solution = Solution { rawSolution::([Int],Int)} deriving (Show,Eq)
```

Normally, the next step should be to define a fitness function but that would make the implementation tightly coupled with the problem that solves. For example, if the implementation is needed to solve the knapsack problem, one of the parameters needed to be passed to the fitness function should be the dataset. Instead, a new type for dataset will be defined. 

For knapsack problem, dataset can be a list of tuples `(g,v)` where $g$ is the weight of the $n^{th}$ object and $v$ is the value of the object.


```haskell
newtype Dataset = Dataset { rawDataset::(Int,[Item])} deriving (Show,Eq)
```

Now a generic fitness function can be defined:


```haskell
fitness::Dataset -> Solution -> Int
fitness dataset solution = fitnessValue
    where
        datasetRaw = rawDataset dataset
        maxWeight = fst datasetRaw
        items = map rawItem (snd datasetRaw)
        individual = fst $ rawSolution solution
        pairs = zip individual items
        weight = foldl (\acc x-> if fst x==1 then acc+fst (snd x) else acc+0) 0 pairs
        value = foldl (\acc x-> if fst x==1 then acc+snd (snd x) else acc+0) 0 pairs
        fitnessValue = if weight <= maxWeight then value else 0
```

Ok, it's not a complicated function but there are a lot of operations that are performed on lists for calculating the fitness value. Step by step is:

1. It accepts 2 parameters of types Dataset and Solution, respectively
2. `datasetRaw = rawDataset dataset` -> get the tuple (G,[(g,v)]), where G is Maximum Weight, g is item's weight and v is item's value.
3. `maxWeight = fst datasetRaw` -> get the maximum weight from the tuple
4. `items = map rawItem (snd datasetRaw)` -> get the list [(g,v)]
5. `individual = fst $ rawSolution solution` -> extract the individual configuration from solution
6. `pairs = zip individual items` -> create pairs of type [(is_item,(g,v))]
7. `weight = foldl (\acc x-> if fst x==1 then acc+fst (snd x) else acc+0) 0 pairs` -> extract total weight for solution
8. `value = foldl (\acc x-> if fst x==1 then acc+snd (snd x) else acc+0) 0 pairs` -> extract total value for solution
9. `fitnessValue = if weight <= maxWeight then value else 0`

Before implementing the function that will calculate the best neighbor in neighborhood, I will need some "helper functions".

1. `replaceNth` is used to replace the value of $n^{th}$ element in a list with a new value.
2. `maximum'` is a function that will get the maximum element from a list of tuples.
3. `calculateNeighborhood` is used to calculate the neighborhood of a solution.


```haskell
replaceNth::Int -> Int->[Int]->[Int]
replaceNth _ _ [] = []
replaceNth index newVal (x:xs)
    | index==0 = newVal:xs
    | otherwise = x:replaceNth (index-1) newVal xs
```


```haskell
maximum'::[([Int],Int)]->([Int],Int)
maximum' [] = error "empty list"
maximum' (x:xs) = maxTail x xs
    where maxTail currentMax [] = currentMax
          maxTail (m,n) (p:ps)
              | n<(snd p) = maxTail p ps
              | otherwise = maxTail (m,n) ps
```


```haskell
calculateNeighborhood::(Dataset->Solution->Int)->Dataset->Solution->Int->[([Int],Int)]->[([Int],Int)]
calculateNeighborhood _ _ _ 0 neighbors = neighbors
calculateNeighborhood f dataset solution len neighbors = calculateNeighborhood f dataset solution (len-1) (neighbor:neighbors)
    where
        raw = fst $ rawSolution solution
        newNeighbor = if raw !! (len-1) == 1 then replaceNth (len-1) 0 raw else replaceNth (len-1) 1 raw
        fitnessValue = f dataset (Solution (newNeighbor,0))
        neighbor = (newNeighbor,fitnessValue)
```

Now the implementation of the function that will calculate the neighborhood can be done. The function will receive as parameters a fitness function, the dataset, current solution and will return a new solution. In other words, the function's type will be `getNewNeighbor::(Dataset->Solution->Int)->Dataset->Solution->Solution`


```haskell
getNewNeighbor::(Dataset->Solution->Int)->Dataset->Solution->Solution
getNewNeighbor f dataset solution = result 
    where
        rawList = fst $ rawSolution solution
        neighbors = calculateNeighborhood f dataset solution (length rawList) []
        result = Solution (maximum' neighbors)
        
```

Now, since the the `getNewNeighbor` and `fitness` functions are implemented, I can define the neighborhood search function.


```haskell
kn::Dataset->Solution->Int->Solution
kn dataset solution numberOfItems
        | snd (rawSolution newSolution) > snd (rawSolution solution) = kn dataset newSolution numberOfItems
        | otherwise = solution
        where newSolution = getNewNeighbor fitness dataset solution
```

### Example

Let's consider a backpack with a maximum capacity of 10 kilograms. There are 4 items with the following characteristics:
1. Item $I_1$ having 6 kg and a value of 50 $\$$
2. Item $I_2$ having 5 kg and a value of 90 $\$$
3. Item $I_3$ having 2 kg and a value of 20 $\$$
4. Item $I_4$ having 4 kg and a value of 30 $\$$



```haskell
dataset=Dataset (10,[Item (6,50), Item (5,90),Item (2,20),Item (4,30)])
```


```haskell
randomValues = Solution (getRandomValueUnsafe 4 0 1,0)
```


```haskell
randomValues
```


    Solution {rawSolution = ([0,1,0,0],0)}



```haskell
fitnessInitial = fitness dataset randomValues
initialSolution = Solution (fst $ rawSolution randomValues,fitnessInitial)
```


```haskell
initialSolution
```


    Solution {rawSolution = ([0,1,0,0],90)}



```haskell
kn dataset initialSolution 4
```


    Solution {rawSolution = ([0,1,0,1],120)}

