(ns main
  (:require [seesaw.core :as s])
  (:require [seesaw.timer :as t])
  (:require [seesaw.color :as c]))

(defn get-time []
  (let [now (java.time.LocalDateTime/now)]
    [(.getHour now) (.getMinute now) (.getSecond now)]))

(defn to-radian [x]
  (- (* x (/ Math/PI 30.0)) (/ Math/PI 2.0)))

(defn paint [c g]
  (let [w (.getWidth c)
        h (.getHeight c)
        r (-> (Math/min w h) (/ 4))
        cx (/ w 2)
        cy (/ h 2)
        [h m s] (get-time)
        hx (+ cx (* 0.3 r (Math/cos (to-radian (* 5 h)))))
        hy (+ cy (* 0.3 r (Math/sin (to-radian (* 5 h)))))
        mx (+ cx (* 0.6 r (Math/cos (to-radian m))))
        my (+ cy (* 0.6 r (Math/sin (to-radian m))))
        sx (+ cx (* 0.9 r (Math/cos (to-radian s))))
        sy (+ cy (* 0.9 r (Math/sin (to-radian s))))]
    (doto g
      (.drawOval (- cx r) (- cy r) (* 2 r) (* 2 r))
      (.drawLine cx cy hx hy)
      (.drawLine cx cy mx my)
      (.setColor (c/color :red))
      (.drawLine cx cy sx sy))))

(def canvas (s/canvas :id :canvas :background "#fff" :paint paint))

(def frame (s/frame :title "Clojure clock"
                    :content canvas
                    :width 800
                    :height 600
                    :on-close :exit))

(defn -main []
  (t/timer (fn [_] (s/repaint! canvas)))
  (s/invoke-later 
   (-> frame
       s/show!)))
