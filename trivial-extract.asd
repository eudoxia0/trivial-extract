(in-package :cl-user)
(defpackage trivial-extract-asd
  (:use :cl :asdf))
(in-package :trivial-extract-asd)

(defsystem trivial-extract
  :version "0.1"
  :author "Fernando Borretti"
  :license "MIT"
  :depends-on (:archive
               :zip
               :deflate
               :cl-fad)
  :components ((:module "src"
                :components
                ((:file "trivial-extract"))))
  :description "Extract .tar/.tar.gz/.zip files."
  :long-description
  #.(uiop:read-file-string
     (uiop:subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op trivial-extract-test))))
