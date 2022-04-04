{
 :title "Decimal to binary conversion in Clojure"
 :layout :post
 :tags  ["clojure","functional programming"]
 :toc true}

---

```clojure
(defn convert-to-binary [value bits]
  (letfn [(to-binary [value bits] 
            (-> value (Integer/toString 2)
                (Integer/parseInt) (->> (format (str "%0" bits "d")))))]
    (let [binary-value (to-binary value bits) result-size (count binary-value)
          default-value (apply str (repeat bits 1))]
      (if (not= result-size bits) default-value  binary-value))))
```
