(in-package :cl-user)
(defpackage trivial-extract-test
  (:use :cl :fiveam))
(in-package :trivial-extract-test)

(defparameter +tmp-dir+
  (asdf:system-relative-pathname :trivial-extract #p"tmp/"))

(defparameter +tar-gz-url+
  "http://ftp5.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-2.1.1p4.tar.gz"
  "We use an OpenSSH tarball, since it should be available for the foreseeable future.")

(defparameter +tar-gz-file+
  (merge-pathnames #p"file.tar.gz" +tmp-dir+)
  "The local path to the downloaded file.")

(defparameter +tar-gz-content-file+
  (merge-pathnames #p"openssh-2.1.1p4/README"
                   +tmp-dir+)
  "A file that will be extracted. We test for its existence.")

(defparameter +zip-url+
  "http://zlib.net/zlib128.zip")

(defparameter +zip-file+
  (merge-pathnames #p"file.zip" +tmp-dir+))

(defparameter +zip-content-file+
  (merge-pathnames #p"zlib-1.2.8/README"
                   +tmp-dir+))

(def-suite extract)
(in-suite extract)

(test setup
  (is-true
   (ensure-directories-exist +tmp-dir+))
  (is-true
    (trivial-download:download +tar-gz-url+ +tar-gz-file+))
  (is-true
    (trivial-download:download +zip-url+ +zip-file+)))

(test extract-tar-and-tar-gz
  (is-true
   ;; This is implicitly a test of both gunzip and extract-tar
   (trivial-extract:extract-gzip +tar-gz-file+)))

(test probe-tar-and-tar-gz
  (is-true
   (probe-file +tar-gz-content-file+)))

(test extract-zip
  (is-true
   (trivial-extract:extract-zip +zip-file+)))

(test probe-zip
  (is-true
   (probe-file +zip-content-file+)))

(test resetup
  (run 'tear-down)
  (run 'setup)
  (is-false
   (probe-file +tar-gz-content-file+))
  (is-false
   (probe-file +zip-content-file+)))

(test best-effort-extraction
  (is-true
   (trivial-extract:extract +tar-gz-file+))
  (run 'probe-tar-and-tar-gz)
  (is-true
   (trivial-extract:extract +zip-file+))
  (run 'probe-zip))

(test tear-down
  (finishes
    (cl-fad:delete-directory-and-files +tmp-dir+)))

(run! 'extract)
