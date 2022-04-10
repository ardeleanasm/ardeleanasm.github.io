{
 :title "Deploy Cryogen blog on Github"
 :layout :post
 :tags  ["shell script"]
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
