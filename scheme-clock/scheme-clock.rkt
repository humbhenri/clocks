#lang racket
(require racket/gui/base)
(require rnrs/arithmetic/fixnums-6)
(require racket/date)

; A simple clock
; Humberto Pinheiro
; Mar 07 2011

;;; Logic Implementation

; The hands point to 0 ~ 60
(define (make-clock)
  (hash 'hour-hand (* 5 (fxmod (date-hour (current-date)) 12))
        'minute-hand (date-minute (current-date))
        'second-hand (date-second (current-date))))

(define the-clock (make-clock))

; Update the clock by 1 sec
(define (tick a-clock)
  (let* ((second-updated (hash-set a-clock 'second-hand (fxmod (+ 1 (hash-ref a-clock 'second-hand)) 60)))
         (minute-updated (hash-set second-updated 'minute-hand (if (= (hash-ref second-updated 'second-hand) 0) 
                                                                   (fxmod (+ 1 (hash-ref second-updated 'minute-hand)) 60)
                                                                   (hash-ref second-updated 'minute-hand)))))
    (if (= (hash-ref minute-updated 'minute-hand) 0)
        (hash-set minute-updated (fxmod (+ 5 (hash-ref minute-updated 'hour-hand))))
        minute-updated)))
  

;;; Gui Functions
; Make a frame by instantiating the frame% class
(define frame (new frame% 
                   [label "Scheme Clock"]
                   [width 360]
                   [height 360]))

; Draw the face and the hands of the clock
(define clock-panel (new canvas% [parent frame]
     [paint-callback
      (lambda (canvas dc)
        (let* ((center-x (/ (send frame get-height) 2.0))
              (center-y (/ (send frame get-width) 2.0))
              (radius (/ (min center-x center-y) 2.0))
              (x (- center-x radius))
              (y (- center-y radius))
              (to-radian (lambda (hand) (- (* hand (/ pi 30.0)) (/ pi 2.0))))
              (hour-x (+ center-x (* 0.3 radius (cos (to-radian (hash-ref the-clock 'hour-hand))))))
              (hour-y (+ center-y (* 0.3 radius (sin (to-radian (hash-ref the-clock 'hour-hand))))))
              (minute-x (+ center-x (* 0.65 radius (cos (to-radian (hash-ref the-clock 'minute-hand))))))
              (minute-y (+ center-y (* 0.65 radius (sin (to-radian (hash-ref the-clock 'minute-hand))))))
              (second-x (+ center-x (* 0.75 radius (cos (to-radian (hash-ref the-clock 'second-hand))))))
              (second-y (+ center-y (* 0.75 radius (sin (to-radian (hash-ref the-clock 'second-hand)))))))
          (send dc set-pen "black" 1 'solid)
          (send dc set-brush "black" 'solid)
          (send dc draw-ellipse x y (* 2 radius) (* 2 radius))
          (send dc set-pen "green" 3 'solid)
          (send dc draw-line center-x center-y hour-x hour-y)
          (send dc draw-line center-x center-y minute-x minute-y)
          (send dc set-pen "red" 1 'solid)
          (send dc draw-line center-x center-y second-x second-y)))]))

(define the-timer (new timer% [notify-callback
                               (lambda () 
                                 (set! the-clock (tick the-clock))
                                 (send clock-panel refresh-now))]))

;;; Main
(send frame show #t)
(send the-timer start 1000 #f)
