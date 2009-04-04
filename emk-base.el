;;;;; Lisp utility functions used by my .emacs file

;; Make elisp work more like Common Lisp.
(require 'cl)

(defmacro define-feature (feature flag)
  "Define a feature to allow conditional compilation with when-feature."
  (eval `(defvar ,feature ,flag))
  nil)

(defmacro when-feature (feature &rest body)
  "Do BODY if FEATURE is true."
  (if (eval feature) `(progn ,@body) nil))

(defmacro safe-add-to-alist (alist &rest entries)
  "Add items to an alist if they don't already have the proper values."
  `(dolist (item ',entries)
     (if (not (eq (cdr (assq (car item) ,alist))
		  (cdr item)))
	 (setq ,alist (cons item ,alist)))))

(defmacro safe-add-items (list &rest items)
  "Add items to the front of a list if they aren't already members."
  `(dolist (item ',items)
     (if (not (memq item ,list))
	 (setq ,list (cons item ,list)))))

(defmacro safe-add-hook (hook function args &rest body)
  "Add a function to a hook only if it is not already present."
  `(progn
     (defun ,function ,args ,@body)
     (add-hook ',hook ',function)))

;;;
;;; Elisp handling
;;;

(defmacro defindent (form value)
  ;; See lisp-mode.el for more information about how this works.
  `(put ',form 'lisp-indent-function ,value))

(defindent when-feature 1)
(defindent safe-add-to-alist 1)
(defindent safe-add-items 1)
(defindent safe-add-hook 3)
(defindent define-mail-abbrevs 0)
(defindent define-dylan-abbrevs 0)
(defindent eval-after-load 1)
(defindent letrec 1)
(defindent snippet-with-abbrev-table 1)