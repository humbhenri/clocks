(defpackage cl-clock/tests/main
  (:use :cl
        :cl-clock
        :rove))
(in-package :cl-clock/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-clock)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
