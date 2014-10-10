(in-package :cl-user)
(defpackage trivial-extract-test-asd
  (:use :cl :asdf))
(in-package :trivial-extract-test-asd)

(defsystem trivial-extract-test
  :author "Fernando Borretti"
  :license "MIT"
  :depends-on (:trivial-extract
               :fiveam
               :trivial-download
               :cl-fad)
  :components ((:module "t"
                :components
                ((:file "trivial-extract")))))
