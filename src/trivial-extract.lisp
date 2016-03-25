(in-package :cl-user)
(defpackage trivial-extract
  (:use :cl)
  (:export :extract-tar
           :extract-gzip
           :extract-zip
           :extract))
(in-package :trivial-extract)

(defmacro try-except (try on-failure)
  `(handler-case
       ,try
       (t () ,on-failure)))

(defun extract (pathname)
  "Best-effort extraction."
  (try-except
   (extract-gzip pathname)
   (try-except
    (extract-tar pathname)
    (extract-zip pathname))))
