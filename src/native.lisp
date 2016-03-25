(in-package :cl-user)
(defpackage trivial-extract.native
  (:use :cl)
  (:export :extract-tar
           :extract-gzip
           :extract-zip)
  (:documentation "Decompression using native command line utilities."))
(in-package :trivial-extract.native)

(defun extract-zip (binary pathname)
  "Extract a .zip file to its containing directory."
  (uiop:run-program (format nil "~S -o ~S -d ~S"
                              (namestring binary)
                              (namestring pathname)
                              (namestring (uiop:pathname-directory-pathname pathname))))
  t)
