(ns main
  (:import [javax.swing JFrame JPanel Timer])
  (:import [java.util Calendar GregorianCalendar])
  (:import [java.awt.event ActionListener])
  (:import [java.awt Color BasicStroke Graphics2D RenderingHints])
  (:gen-class))

(def the-clock (atom {:hour-hand 0 :minute-hand 0 :second-hand 0}))

(defn update-clock [aClock]
  (let [mod-inc #(mod (inc %) 60)
	second-updated (assoc aClock :second-hand
			      (mod-inc (aClock :second-hand)))
	minute-updated (if (= (second-updated :second-hand) 0)
			 (assoc second-updated :minute-hand
				(mod-inc (second-updated :minute-hand)))
			 second-updated)]
    (if (= (minute-updated :minute-hand) 0)
      (assoc minute-updated :hour-hand
	     (mod (+ 5 (minute-updated :hour-hand)) 60))
      minute-updated)))

(defn set-time []
  (let [now (GregorianCalendar.)
	hour (* 5 (.get now (Calendar/HOUR)))
	minute (.get now (Calendar/MINUTE))
	second (.get now (Calendar/SECOND))]
    {:hour-hand hour :minute-hand minute :second-hand second}))

(defn window [title]
  (doto (JFrame. title)
    (.setDefaultCloseOperation JFrame/EXIT_ON_CLOSE)))

(defn clock-panel []
  (proxy [JPanel ActionListener] []
    (paintComponent [g]
      (proxy-super paintComponent g)
      (let [g (cast Graphics2D g)
	    center-x (/ (.getWidth this) 2)
	    center-y (/ (.getHeight this) 2)
	    radius (/ (Math/min (.getHeight this) (.getWidth this)) 4.0)
	    x (- center-x radius)
	    y (- center-y radius)
	    hour-hand (@the-clock :hour-hand)
	    minute-hand (@the-clock :minute-hand)
	    second-hand (@the-clock :second-hand)
	    to-radian #(- (* % (/ Math/PI 30.0)) (/ Math/PI 2.0))
	    hour-x (+ center-x (* 0.3 radius (Math/cos (to-radian hour-hand))))
	    hour-y (+ center-y (* 0.3 radius (Math/sin (to-radian hour-hand))))
	    minute-x (+ center-x (* 0.6 radius (Math/cos (to-radian minute-hand))))
	    minute-y (+ center-y (* 0.6 radius (Math/sin (to-radian minute-hand))))
	    second-x (+ center-x (* 0.75 radius (Math/cos (to-radian second-hand))))
	    second-y (+ center-y (* 0.75 radius (Math/sin (to-radian second-hand))))]
	(.setRenderingHint g RenderingHints/KEY_ANTIALIASING RenderingHints/VALUE_ANTIALIAS_ON)
	(.fillOval g x y (* 2 radius) (* 2 radius))
	(.setColor g Color/GREEN)
	(.setStroke g (BasicStroke. 3.0))
	(.drawLine g center-x center-y hour-x hour-y)
	(.drawLine g center-x center-y minute-x minute-y)
	(.setColor g Color/RED)
	(.setStroke g (BasicStroke. 1.0))
	(.drawLine g center-x center-y second-x second-y)))
    (actionPerformed [evt]
      (swap! the-clock update-clock)
      (.repaint this))))

(defn -main [& args]
  (let [frame (window "Clojure clock")
	panel (clock-panel)
	interval 1000
	timer (Timer. interval panel)]
    (reset! the-clock (set-time))
    (doto frame
      (.add panel)
      (.pack)
      (.setSize 360 360)
      (.setVisible true))
    (.start timer)))
