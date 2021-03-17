(defpackage cl-clock
  (:use :cl :ltk)
  (:export :toplevel))
(in-package :cl-clock)


(defparameter *window-width* 400)
(defparameter *window-height* 400)

(defconstant hour-hand-size 0.1)
(defconstant minute-hand-size 0.3)
(defconstant second-hand-size 0.4)

(defparameter *hour* 0)
(defparameter *minute* 0)
(defparameter *second* 0)


(defun to-radian (x) (- (* x (/ PI 30.0)) (/ PI 2.0)))


(defun draw-clock (canvas)
  (clear canvas)
  (let* ((width  *window-width*)
         (height  *window-height*)
         (size (* 0.75 (min width height)))
         (start-x (- (/ width 2) (/ size 2)))
         (start-y (- (/ height 2) (/ size 2)))
         (center-x (/ width 2))
         (center-y (/ height 2))
	       (hour-x (+ center-x (* hour-hand-size size (cos (to-radian *hour*)))))
	       (hour-y (+ center-y (* hour-hand-size size (sin (to-radian *hour*)))))
	       (minute-x (+ center-x (* minute-hand-size size (cos (to-radian *minute*)))))
	       (minute-y (+ center-y (* minute-hand-size size (sin (to-radian *minute*)))))
	       (second-x (+ center-x (* second-hand-size size (cos (to-radian *second*)))))
	       (second-y (+ center-y (* second-hand-size size (sin (to-radian *second*)))))
         (clock (create-oval canvas start-x start-y (- width start-x) (- height start-y)))
         (hour (create-line canvas (list center-x center-y hour-x hour-y)))
         (minute (create-line canvas (list center-x center-y minute-x minute-y)))
         (second (create-line canvas (list center-x center-y second-x second-y))))
    (itemconfigure canvas second 'fill "red")
    (itemconfigure canvas hour 'width 2)))


(defun update-time ()
  (multiple-value-bind (s m h) (get-decoded-time)
    (setq *hour* h)
    (setq *minute* m)
    (setq *second* s)))


(defun redraw-clock (canvas)
  (update-time)
  (draw-clock canvas)
  (after 1000 (lambda () (redraw-clock canvas))))


(with-ltk () (let* ((canvas (make-instance
                             'canvas :height *window-width* :width *window-height*)))
               (bind canvas "<Configure>"
                     (lambda (evt)
                       (setq *window-width* (event-width evt))
                       (setq *window-height* (event-height evt))
                       (draw-clock canvas)))
               (pack canvas :fill :both :expand :yes)
               (force-focus canvas)
               (redraw-clock canvas)
               (process-events)))
