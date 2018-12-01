(ns day20)

(defn read-input []
  (->> "day20input.txt"
       slurp
       clojure.string/split-lines
       (map #(->> %
                  (re-seq #"-?\d+")
                  (map read-string)
                  (partition 3)))))

; PART 1

(defn dist-from-zero [vec]
  (apply + (map #(Math/abs %) vec)))

(defn part1 []
  (sort-by (juxt #(dist-from-zero (last %)) #(dist-from-zero (second %)))
           (read-input)))

; PART 2

(defn step-particle [[p v a]]
  "Update particle's position and velocity."
  (let [new-v (mapv + v a)]
    [(mapv + p new-v) new-v a]))

(defn remove-collisions [particles]
  "Omit all colliding particles."
  (let [freqs (frequencies (map first particles))]
    (filter #(<= (get freqs (first %)) 1) particles)))

(defn step [particles]
  "Move the simulation ahead by one step."
  (remove-collisions (map step-particle particles)))

(defn part2 []
  (->> (read-input)
       (iterate step)
       (take 100)
       last
       count))
