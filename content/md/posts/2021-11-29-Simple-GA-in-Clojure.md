{
 :title "Simple GA in Clojure"
 :layout :post
 :tags  ["clojure", "functional programming","heuristics"]
 :toc true}


In this blog post I’ll present a simple Genetic Algorithm implementation made in Clojure. The application is based on the one presented by Lee Spector in [HERE](https://gist.github.com/lspector/1291789?fbclid=IwAR3NHmrqQVDgmPrtKg6L_nPCc70KCK2xsZ2h98k5-Cw7bN-2R96a0t6S6kc).
The task of the Genetic Algorithm is to evolve, starting from random generated individuals, to a sequence of bits that sums to a particular number.

```clojure
(defn new-individual
    "Function used for creating a new individual"
    [genome-length]
    {:genome (vec (repeatedly genome-length #(rand-int 2))) :fitness 0}
    )

```

The genome for each individual is generated using **new-individual** function and is represented by a vector of **genome-length** random bits. Such, the population can be generated using `(repeatedly population-size #(new-individual genome-length))`

We will define a fitness function that is used to calculate the fitness for a specific individual as:

```clojure
(defn fitness-function 
    [genome, target]
    (Math/abs (- (reduce + genome) target))
)
```

The fitness function of an individual is represented by the difference between the targeted number and the sum of the bits. The parameters of the **fitness-function** are the **genome** (the vector of bits) and the **target** number. In order to apply it on the entire population we will need to define a new function such as:

```clojure
(defn calculate-fitness
    [population, target]
    (letfn [(fitness-function-helper 
        [individual, target]
        (assoc individual :fitness (fitness-function (individual :genome) target))
    )]
    	    (map (fn [individual] (#(fitness-function-helper individual target))) population)
    )
    
)
```

that takes the population and the targeted number as parameters and maps the fitness function on the population.

```clojure
(defn get-best-individual [population]
		(letfn [(better [i1 i2]
					(< (i1 :fitness) (i2 :fitness))
				)]
			(first (sort better population))
		)
)
```

The helper function **get-best-individual** is used to extract the best individual from the population.

Finally, we define the crossover operator as:

```clojure
(defn crossover
        [first-individual, second-individual, crossover-rate, target]
        (let [new-genome (mapv (fn [i1,i2] (let [crossover-probability (rand)]
                                        (cond
                                            (<= crossover-probability crossover-rate) i1
                                            :else i2
                                        )
                                    )
                            ) 
            (first-individual :genome) (second-individual :genome)
                )]
            {:genome new-genome :fitness (fitness-function new-genome target)}
        )
        
)
```

The crossover operator maps an anonymous function that takes the genomes of two individuals and creates a new genome.

```clojure
(defn mate-individuals [population, population-size, crossover-rate, target, tournament-size]
	(letfn [(tournament-selection [population, population-size, tournament-size, target]
				(loop [steps 0 new-population ()]
					(if (< steps tournament-size)
						(recur (inc steps) (conj new-population (nth population ((comp rand-int -) population-size 2))))
						(get-best-individual (calculate-fitness new-population target))
					)
				)
		)]
				(loop [steps 0 new-population ()]
					(if (< steps population-size)
						(let [i1 (tournament-selection population population-size tournament-size target)]
							(let [i2 (tournament-selection population population-size tournament-size target)]
								(let [offs (crossover i1 i2 crossover-rate target)]
									(recur (inc steps) (conj new-population offs))
								)
							)
						)
						new-population
					)
				)
	)
)
```

The **mate-individuals** function perform selection using **tournament-selection** and apply crossover operator on the entire population.

```clojure
(defn mutate-population [population, population-size, genome-length, target]
			
			(letfn [(mutate [individual, genome-length, target]
					(let [new-genome (assoc (individual :genome) (rand-int genome-length) (rand-int 2))]
    		{:genome new-genome :fitness (fitness-function new-genome target)}
  			)
				)]
				(loop [steps 0 new-population ()]
        (if (< steps population-size)
                (recur (inc steps) (conj new-population (mutate (nth population steps) genome-length target)))
                new-population
        )

    )

			)
    

)
```

The **mutate-populatio**n performs the mutation of each individual from the population.

Finally, we define the **evolve** function such as:

```clojure
(defn evolve [population-size, genome-length, target, number-of-generations, crossover-rate, tournament-size]
(loop [generation 0 population (calculate-fitness (repeatedly population-size #(new-individual genome-length)) target) best {}]
	(if (and (< generation number-of-generations) (not= 0 (best :fitness)))
			
				
				(let [offsprings (mate-individuals population population-size crossover-rate target tournament-size)]
					(let [new-population (mutate-population offsprings population-size genome-length target)]
						(let [best-individual (get-best-individual new-population)]
							(do
								(printf "Generation %s -> best individual %s%n" generation best-individual)

								(recur (inc generation) new-population best-individual)
							)
						)
					)
					
				)
				best
	)

)
)
```

This function generates an initial assessed population and while the termination conditions are not met, it creates new offsprins by mating the individuals and mutating them. The termination conditions are represented by the maximum number of generations and by the finding of the best individual.

Finally, we can run the algorithm as `(println (evolve 100 100 1 100 0.3 10))` and the output will be:

```
Generation 0 -> best individual {:genome [0 0 1 0 0 1 0 1 0 1 1 1 0 0 1 1 0 0 1 0 1 0 0 0 0 0 0 1 1 0 0 0 0 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 1 1 1 0 1 0 1 1 0 0 0 0 0 0 1 0 0 1 0 1 0 0 1 1 1 0 0 0 0 0 1 0 0 0 1], :fitness 35}                                          
Generation 1 -> best individual {:genome [0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 1 0 0 1 1 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 1 0 0 0 0 0 0 1 0 1 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 1 0 1 1 0 0 1 0 1 1 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0 0 1 0 0], :fitness 29}                                          
Generation 2 -> best individual {:genome [0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 1 1 0 1 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 1 0 1 1 1 0 1 0 0 0 1 0 0 1 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 1 0 0], :fitness 24}                                          
Generation 3 -> best individual {:genome [0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0], :fitness 18}                                          
Generation 4 -> best individual {:genome [0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0], :fitness 16}                                          
Generation 5 -> best individual {:genome [0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0 0 1 0 0], :fitness 12}                                          
Generation 6 -> best individual {:genome [0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0], :fitness 11}                                          
Generation 7 -> best individual {:genome [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0], :fitness 9}                                           
Generation 8 -> best individual {:genome [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 0 0], :fitness 6}                                           
Generation 9 -> best individual {:genome [0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 0 0], :fitness 4}                                           
Generation 10 -> best individual {:genome [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0], :fitness 2}                                          
Generation 11 -> best individual {:genome [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0], :fitness 1}                                          
Generation 12 -> best individual {:genome [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0], :fitness 0}                                          
{:genome [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0], :fitness 0}
```
