(import math)
(import time)
(import tkinter [Tk Canvas Frame BOTH ALL])

(setv width 1024)
(setv height 768)
(setv delay 1000)
(setv root (Tk))

(defn to-radian [x]
  (- (* x (/ math.pi 30.0)) (/ math.pi 2.0)))

(defn get-time []
  (let [t (time.localtime)]
    #(t.tm_hour t.tm_min t.tm_sec)))

(defclass Clock[Frame]
  (defn __init__ [self parent]
    (Frame.__init__ self parent)
    (setv self.parent parent)
    (setv self.canvas (Canvas self :width width :height height))
    (setv [self.hour self.minute self.second] (get-time))
    (self.on-timer)
    (self.draw))

  (defn on-timer [self]
    (self.tick)
    (self.canvas.delete ALL)
    (self.draw)
    (self.after delay self.on-timer))

  (defn tick [self]
    (setv self.second (% (+ 1 self.second) 60))
    (when (= self.second 0)
      (setv self.minute (% (+ 1 self.minute) 60))
      (when (= self.minute 0)
        (setv self.hour (% (+ 1 self.hour) 12)))))

  (defn draw [self]
    (self.pack :fill BOTH :expand 1)
    (self.update)
    (let [radius (/ (min (self.winfo_width) (self.winfo_height)) 2.0)
          x0 (- (/ (self.winfo_width) 2) radius)
          y0 (- (/ (self.winfo_height) 2) radius)
          x1 (+ (/ (self.winfo_width) 2) radius)
          y1 (+ (/ (self.winfo_height) 2) radius)
          centerx (/ (self.winfo_width) 2)
          centery (/ (self.winfo_height) 2)
          hour-hand (* (% self.hour 12) 5)
          hourx (+ centerx (* (/ radius 2) (math.cos (to-radian hour-hand))))
          houry (+ centery (* (/ radius 2) (math.sin (to-radian hour-hand))))
          minutex (+ centerx (* radius 0.75 (math.cos (to-radian self.minute))))
          minutey (+ centery (* radius 0.75 (math.sin (to-radian self.minute))))
          secondx (+ centerx (* radius 0.85 (math.cos (to-radian self.second))))
          secondy (+ centery (* radius 0.85 (math.sin (to-radian self.second))))]
      (self.canvas.create_oval x0 y0 x1 y1 :outline "black" :width 2)
      (self.canvas.create_line centerx centery hourx houry :width 2 :fill "green")
      (self.canvas.create_line centerx centery minutex minutey :width 2 :fill "green")
      (self.canvas.create_line centerx centery secondx secondy :width 1 :fill "red")
      (self.canvas.pack :fill BOTH :expand 1))))

(defn resize [e]
  (clock.canvas.delete "all")
  (clock.draw))

(root.geometry f"{width}x{height}+300+300")
(root.title "clock")
(setv clock (Clock root))
(root.bind "<Configure>" resize)
(root.mainloop)

