{
  :title "Vicsek fractal"
  :layout :post
  :tags ["clojure"]
  :toc true}
 
 ---
  
```clojure

(def header-xml "<?xml version=\"1.0\"?>")
(def header-svg "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">")
(def footer "\"/>\n</svg>")

(defn append-to-file
  [file-name s]
  (spit file-name s :append true))



(defn print-line [x y len file]
  (append-to-file file (str "M " x " " y))
  (append-to-file file (str "h " len))
  (append-to-file file (str "v " len))
  (append-to-file file (str "h " (- 0 len)))
  (append-to-file file (str "v -" len))  
  )

(defn fractal-cross [x y len file]
  (if (< len 3)
    (print-line x y len file)
    (let [l3 (/ len 3.0) l23 (* l3 2)]
      (fractal-cross x y l3 file)
      (fractal-cross (+ x l23) y l3 file)
      (fractal-cross (+ x l3) (+ y l3) l3 file)
      (fractal-cross x (+ y l23) l3 file)
      (fractal-cross (+ x l23) (+ y l23) l3 file))))

(defn run [x,y,len file]
  (let [content "<path d=\""]
    (append-to-file file header-xml)
    (append-to-file file header-svg)
    (append-to-file file content)
    (fractal-cross x y len file)
    (append-to-file file footer)))


(run 0.0 0.0 729.0 "test.svg")


```
