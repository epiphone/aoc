(ns day20)

; (defrecord Vec3 [x y z])
; (defrecord Particle [p v a])

(defn manhattan-distance [v1 v2]
  (apply + (mapv (comp #(Math/abs %) -) v1 v2)))

(defn update-particle [[p v a]]
  (let [new-v (mapv + v a)]
    [(mapv + p new-v) new-v a]))

(defn read-input []
  (->> "day20input.txt"
       slurp
       clojure.string/split-lines
       (map #(->> %
                  (re-seq #"-?\d+")
                  (map read-string)
                  (partition 3)))))

(defn step [n]
  (loop [i n particles (read-input)]
    (if (zero? i)
      particles
      (recur (dec i) (map update-particle particles)))))

(defn closest-to-zero [particles]
  (apply min-key #(manhattan-distance [0 0 0] (first %)) particles))

(defn -main []
  ())
