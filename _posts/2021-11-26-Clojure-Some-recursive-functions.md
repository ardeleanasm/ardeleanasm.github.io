---
layout: blog/post
title: "Clojure -> Some recursive functions"
description: "Clojure -> Some recursive functions"
category: Clojure,Functional Programming
tags: Functional Programming, clojure, clojure
---

```clojure
(defn fibonacci
  ([n]
    (fibonacci [0 1] n))
  ([x,n]
    (if (< (count x) n)
      (fibonacci (conj x (+ (last x) (nth x (- (count x) 2)))) n)
    x))
)

(defn factorial [n]
  (cond 
    (= n 0)  1
    (> n 0) (* n (factorial (- n 1)))
    )
)

(defn collatz [n,s]
  (if (not= n 1)
    (cond 
      (even? n) (collatz (/ n 2) (+ 1 s) )
      (odd? n) (collatz (+ (* 3 n) 1) (+ 1 s))
    )
    s )
)

(defn collatz-sequence [n s]
  (do (println n) 
    (if (not= n 1)
      (cond 
        (even? n) (collatz-sequence (/ n 2) (+ 1 s) )
        (odd? n) (collatz-sequence (+ (* 3 n) 1) (+ 1 s))
      )
    )

  )
)

(println (collatz 141151 0))
(collatz-sequence 1441151 0)
```
