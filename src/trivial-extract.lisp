(in-package :cl-user)
(defpackage trivial-extract
  (:use :cl)
  (:export :extract-tar
           :extract-gzip
           :extract-zip
           :extract))
(in-package :trivial-extract)

(defun gunzip (tar-gz-file tar-file)
  "Extract a .tar.gz file into a .tar archive."
  (with-open-file (input-stream tar-gz-file
                                :element-type '(unsigned-byte 8))
    (with-open-file (output-stream tar-file
                                   :direction :output
                                   :if-exists :supersede
                                   :element-type '(unsigned-byte 8))
      (deflate:inflate-gzip-stream input-stream output-stream)
      t)))

(defun extract-tar (pathname)
  "Extract a tarball to its containing directory."
  ;; archive, by default, extracts all entries to *default-pathname-defaults*,
  ;; so we have to override its value to the directory that contains the archive
  (let ((current-dpf *default-pathname-defaults*))
    (setf *default-pathname-defaults*
          (make-pathname :directory (pathname-directory pathname)))
    (archive:with-open-archive (archive pathname)
      (archive:do-archive-entries (entry archive)
        (archive:extract-entry archive entry)))
    (setf *default-pathname-defaults* current-dpf)
    t))

(defun extract-gzip (pathname)
  "Extract a .tar.gz file to its containing directory."
  (let ((resulting-tarball (make-pathname :defaults pathname
                                          :type "tar-temporary")))
    (gunzip pathname resulting-tarball)
    (extract-tar resulting-tarball)
    (delete-file resulting-tarball)
    t))

(defun extract-zip (pathname)
  "Extract a .zip file to its containing directory."
  (zip:unzip pathname (cl-fad:pathname-directory-pathname pathname))
  t)

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
