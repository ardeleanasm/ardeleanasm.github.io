{
  :title "Fractal canopy"
  :layout :post
  :tags ["clojure", "fractals"]
  :toc true}
 
 ---
  
```clojure
(ns fractals.core
  (:gen-class))

(def tree-fractal-file "tree.svg")


(defn append-to-file
  "Uses spit to append to a file specified with its name as a string, or
   anything else that writer can take as an argument.  s is the string to
   append."     
  [file-name s]
  (spit file-name s :append true))



(def header-xml "<?xml version=\"1.0\"?>")
(def header-svg "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">")
(def footer "\" stroke=\"black\" stroke-width=\"1\"/>\n</svg>")



(defn map-y-coordinate [y]
  (- 600 y))

(defn draw-line [x y x1 y1 file]
  (append-to-file file (str " M " x " " (map-y-coordinate y)))
  (append-to-file file (str " L " x1 " " (map-y-coordinate y1)))
  )

(defn draw-tree [x y angle depth len fork-angle]
  (if (> depth 0)
    (let [x2 (- x (* (Math/sin (Math/toRadians angle)) depth len))
          y2 (- y (* (Math/cos (Math/toRadians angle)) depth len))]
      (draw-line x y x2 y2 tree-fractal-file)
      (draw-tree x2 y2 (- angle fork-angle) (- depth 1) len fork-angle)
      (draw-tree x2 y2 (+ angle fork-angle) (- depth 1) len fork-angle)
      )))


(defn run-tree []
  (let [content "<path d=\""
        
        ]
    (append-to-file tree-fractal-file header-xml)
    (append-to-file tree-fractal-file header-svg)
    (append-to-file tree-fractal-file content)
    (draw-tree 600 50 180 10 10 20)
    (append-to-file tree-fractal-file footer)
    ))

(defn -main
  [& args]
  ;;  (run 0.0 0.0 729.0 )
  (run-tree)
  )
```