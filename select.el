;;; select.el - A reimplementation of the LISP machine's select key.
;;; Unreleased proof-of-Concept version, 19 Nov 1999.
;;;
;;; Inspired by Martin Cracauer's implementation at
;;; <http://www.cons.org/cracauer/configuration.html>.
;;;
;;; This is just a hairball of code right now, suitable for pasting into a
;;; '.emacs' and editing for your system. I may clean it up and release it
;;; someday.
;;;      
;;; FEATURES:
;;; 
;;;   * Switch to most recently used C source, C header or LISP file.
;;;   * Configurable--just hack the source. :-)
;;;   * Toggles between two most recent buffers of a given type.
;;;   * Uses SUPER by default, for two-key access.
;;;   * Some extra, non-standard SUPER bindings for switching to particular
;;;     buffers.
;;;   * Support for identifying buffers using arbitrary predicates.
;;;   
;;; BUGS:
;;;
;;;   * Calling describe-key on some of the anonymous keybindings will die.
;;;   * select:switch-to-next-matching-buffer will make a mess of your
;;;     history list. It should only record the last buffer you choose.
;;;     Unfortunately, this is a non-trivial problem which will require
;;;     reading some Emacs source.
;;;   * Need better names for select:make-raw-switch-command and
;;;     select:make-switch-command.
;;;   * Should allow arbitrary code to be executed if no buffers match.
;;;   * Comments? Yeah, some of those would have been nice.
;;;
;;; USEFUL FUNCTIONS:
;;;   * select:make-raw-switch-command
;;;   * select:make-switch-command
;;;   * select:switch-to-next-matching-buffer
;;;
;;; Eric Kidd
;;; <eric.kidd@pobox.com>

(defvar select:*alternate-buffers* nil)

(defun select:buffer-match-p (predicate-or-regex buffer)
  "Return true if 'buffer' matches 'predicate-or-regex'."
  (cond ((stringp predicate-or-regex)
	 (string-match predicate-or-regex (buffer-name buffer)))
	((functionp predicate-or-regex)
	 (funcall predicate-or-regex buffer))
	(t
	 (error "Unrecognized predicate type in select:buffer-match-p."))))

(defun select:find-matching-buffers (predicate-or-regex)
  "Return all the buffers matching 'predicate-or-regex'."
  (select:find-matching-buffers-recursive predicate-or-regex (buffer-list)))

(defun select:find-matching-buffers-recursive (predicate-or-regex buffers)
  "Return all items in 'buffers' which match 'predicate-or-regex'."
  (if buffers
      (let ((tail (select:find-matching-buffers-recursive predicate-or-regex
							  (cdr buffers))))
	(if (select:buffer-match-p predicate-or-regex (car buffers))
	    (cons (car buffers) tail)
	  tail))
    nil))

(defun select:switch-to-first-matching-buffer (predicate-or-regex)
  "Switch to the most recently used buffer matching 'predicate-or-regex'."
  (let ((buffers (select:find-matching-buffers predicate-or-regex)))
    (if (and buffers (eql (car buffers) (current-buffer)))
	(setq buffers (cdr buffers)))
    (if (not buffers)
	(error "No matching buffers are open.")
      (switch-to-buffer (car buffers))
      (setq select:*alternate-buffers* (cdr buffers)))))

(defun select:switch-to-next-matching-buffer ()
  "Switch to the next most recent buffer matching a pattern."
  (interactive)
  (if (not select:*alternate-buffers*)
      (error "No more matching buffers.")
    (switch-to-buffer (car select:*alternate-buffers*))
    (setq select:*alternate-buffers* (cdr select:*alternate-buffers*))))

(defun select:make-raw-switch-command (predicate-or-regex)
  "Construct a command which calls select:find-matching-buffers."
  `(lambda ()
     ,(format "Switch to first buffer matching '%s'." predicate-or-regex)
     (interactive)
     (select:switch-to-first-matching-buffer ,predicate-or-regex)))

(defun select:make-switch-command (extensions)
  (select:make-raw-switch-command
   (concat "\\.\\("
	   (select:join-strings "\\|" extensions)
	   "\\)\\(<[0-9]+>\\)?\\'")))

(defun select:join-strings (joiner strings)
  "Join the strings in 'strings' together using 'joiner' (like Perl's join)."
  (cond ((not strings)
	 "")
	((cdr strings)
	 (concat (car strings)
		 joiner
		 (select:join-strings joiner (cdr strings))))
	(t
	 (car strings))))

;;; Sample bindings
;;;
;;; These are temporary demo bindings.

(global-set-key [s-tab] 'select:switch-to-next-matching-buffer)

(global-set-key [?\s-l] (select:make-switch-command '("lsp" "lisp" "el")))
(global-set-key [?\s-c] (select:make-switch-command '("c" "cpp" "cp" "cc")))
(global-set-key [?\s-h] (select:make-switch-command '("h")))

(global-set-key [?\s-t] (select:make-raw-switch-command "\\`TODO"))
(global-set-key [?\s-m] (select:make-raw-switch-command "\\`*Man "))
(global-set-key [?\s-r] (select:make-raw-switch-command "\\`README"))
(global-set-key [?\s-b] (select:make-raw-switch-command "*build*"))
(global-set-key [?\s-a] (select:make-raw-switch-command "\\`\\(Makefile\\|configure.in\\)"))
(global-set-key [?\s-g] (select:make-raw-switch-command "*gud-"))

;; "Creator" bindings for some of the buffer types above.
(global-set-key [?\s-\C-g] 'gdb)
(global-set-key [?\s-\C-m] 'man)

(global-set-key [?\s-z] 'shell)
(global-set-key [?\s-n] 'run-lisp)
(global-set-key [?\s-k] 'compile)
(global-set-key [?\s-`] 'next-error)
