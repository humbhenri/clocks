(defsystem "cl-clock"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "cl-clock/tests"))))

(defsystem "cl-clock/tests"
  :author ""
  :license ""
  :depends-on ("cl-clock"
               "rove"
               "ltk")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for cl-clock"
  :perform (test-op (op c) (symbol-call :rove :run c)))
