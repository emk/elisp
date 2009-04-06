;;; select.el - A reimplementation of the LISP machine's select key.
;;; Proof-of-Concept version, 19 Nov 1999.
;;; Updated April 2009.
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


;;=========================================================================
;;  Generating lists of matching buffers
;;=========================================================================

;; Return true if 'buffer' matches 'predicate-or-regex'.
(defun select::buffer-match-p (predicate-or-regex buffer)
  (cond ((stringp predicate-or-regex)
	 (string-match predicate-or-regex (buffer-name buffer)))
	((functionp predicate-or-regex)
	 (funcall predicate-or-regex buffer))
	(t
	 (error "Unrecognized predicate type in select:buffer-match-p."))))

;; "Return all items in 'buffers' which match 'predicate-or-regex'."
(defun select::find-matching-buffers (predicate-or-regex)
  (loop for buffer in (buffer-list)
        if (select::buffer-match-p predicate-or-regex buffer)
        collect buffer))


;;=========================================================================
;;  Switching to a buffer
;;=========================================================================

;; When this timer fires, it will run select::record-visit-to-buffer.
(defvar select::*buffer-list-update-timer* nil)

;; The last buffer we visited using select:switch-to-buffer.
(defvar select::*stopped-at-buffer* nil)

;; If we're still in select::*stopped-at-buffer*, add it to the list of
;; recently visited buffers.
(defun select::record-visit-to-buffer ()
  (setq select::*buffer-list-update-timer* nil)
  (when (eq (current-buffer) select::*stopped-at-buffer*)
    (switch-to-buffer (current-buffer))))

(defun select:switch-to-buffer (buffer)
  "Switch to 'buffer', updating recently selected buffers only if we stay."
  (interactive "bBuffer: ")
  (switch-to-buffer buffer t)
  (setq select::*stopped-at-buffer* (current-buffer))
  (when select::*buffer-list-update-timer*
    (cancel-timer select::*buffer-list-update-timer*)
    (setq select:*buffer-list-update-timer* nil))
  (setq select::*buffer-list-update-timer*
        (run-at-time "2 sec" nil 'select::record-visit-to-buffer)))

(defun select:currently-cycling-p ()
  "Returns true if we're currently cycling through a list of buffers."
  (and select::*buffer-list-update-timer* t))


;;=========================================================================
;;  Cycling through lists of buffers
;;=========================================================================

;; The pattern we used for generating 'select::*buffers-to-visit*'.
(defvar select::*most-recent-predicate-or-regex* nil)

;; A list of buffers to visit.
(defvar select::*buffers-to-visit* nil)

;; A list of buffers we've already visited.
(defvar select::*buffers-visited* nil)

(defun select:switch-to-next-buffer ()
  "Switch to the next buffer in the most recent select cycle."
  (interactive)
  (unless select::*buffers-to-visit*
    (error "No more matching buffers."))
  (push (pop select::*buffers-to-visit*) select::*buffers-visited*)
  (select:switch-to-buffer (car select::*buffers-visited*)))

(defun select:switch-to-prev-buffer ()
  "Switch to the next buffer in the most recent select cycle."
  (interactive)
  (unless (and select::*buffers-visited* (cdr select::*buffers-visited*))
    (error "No more matching buffers."))
  (push (pop select::*buffers-visited*) select::*buffers-to-visit*)
  (select:switch-to-buffer (car select::*buffers-visited*)))

(defun select:switch-to-buffer-matching (predicate-or-regex)
  """Switch to a buffer matching 'predicate-or-regex'.

If called repeatedly with an 'equal' value of 'predicate-or-regex', cycles
through all matching buffers."""
  (interactive "sBuffer regex: ")
  (unless (and (select:currently-cycling-p)
               (equal predicate-or-regex
                      select::*most-recent-predicate-or-regex*))
    (setq select::*most-recent-predicate-or-regex* predicate-or-regex)
    (setq select::*buffers-to-visit*
          (remove (current-buffer)
                  (select::find-matching-buffers predicate-or-regex)))
    (setq select::*buffers-visited* (list (current-buffer))))
  (select:switch-to-next-buffer))


;;=========================================================================
;;  Switch commands
;;=========================================================================

(defun select:make-raw-switch-command (predicate-or-regex)
  "Construct a command which calls select:find-matching-buffers."
  `(lambda ()
     ,(format "Switch to first buffer matching '%s'." predicate-or-regex)
     (interactive)
     (select:switch-to-buffer-matching ,predicate-or-regex)))

(defun select:make-switch-command (extensions)
  (select:make-raw-switch-command
   (concat "\\." (regexp-opt extensions t) "\\(<[0-9]+>\\)?\\'")))

;;; Sample bindings
;;;
;;; These are temporary demo bindings.

(global-set-key [?\s-\[] 'select:switch-to-prev-buffer)
(global-set-key [?\s-\]] 'select:switch-to-next-buffer)

(global-set-key [?\s-l] (select:make-switch-command '("lsp" "lisp" "el")))
(global-set-key [?\s-c] (select:make-switch-command '("c" "cpp" "cp" "cc")))
(global-set-key [?\s-h] (select:make-switch-command '("h")))
(global-set-key [?\s-r] (select:make-switch-command '("rb")))
