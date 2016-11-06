;;; wc-mode.el --- show length of buffer in status bar


;; Copyright (C) 2011 Toby Cubitt

;; Author: Toby Cubitt <toby-predictive@dr-qubit.org>
;; Version: 0.1
;; Keywords: length, characters, words, lines, mode line
;; URL: http://www.dr-qubit.org/emacs.php


;; This file is NOT part of Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
;; MA 02110-1301, USA.


;;; Commentary:
;;
;; A simple minor-mode to display the length of the buffer in the status bar.


;;; Change log:
;;
;; Version 0.1
;; * initial release



;;; Code:

(provide 'wc-mode)


;;; Allegedly from here: http://www.delorie.com/gnu/docs/emacs-lisp-intro/emacs-lisp-intro_toc.html
;;; First version; has bugs!
(defun count-words-region (beginning end)
  "Print number of words in the region.
Words are defined as at least one word-constituent
character followed by at least one character that
is not a word-constituent.  The buffer's syntax
table determines which characters these are."
  (save-excursion
    (goto-char beginning)
    (let ((count 0))
      (while (< (point) end)
        (re-search-forward "\\w+\\W*")
        (setq count (1+ count)))
      count)))


;; add length display to mode-line construct
(setq mode-line-position (assq-delete-all 'wc-mode mode-line-position))
;; FIXME: only shows total characters at the moment
(setq mode-line-position
      (append
       mode-line-position
       '((wc-mode
	  (6 (:eval (format " %d,%d,%d"
			    (point-max)
			    (count-words-region (point-min) (point-max))
			    (line-number-at-pos (point-max)))))
	  nil))))


(define-minor-mode wc-mode
  "Toggle word-count mode.
With no argument, this command toggles the mode.
A non-null prefix argument turns the mode on.
A null prefix argument turns it off.

When enabled, the total number of characters, words, and lines is
displayed in the mode-line.")


;;; wc-mode.el ends here
