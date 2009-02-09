;; git-tools.el --- Some handy git-related commands
;; Copyright 2009 Eric Kidd

;; Author: Eric Kidd <http://www.randomhacks.net/>
;; Keywords: git

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This file contains miscellaneous assorted commands which are helpful for
;; working with git.  To use it, you need contrib/emacs/git-blame.el from
;; the git distribution, and magit from
;; http://zagadka.vm.bytemark.co.uk/magit/ .
;; 
;; To set it up, add something like the following to your .emacs:
;;
;;   (require 'magit)
;;   (autoload 'git-blame-mode "git-blame" "Git blame mode" t)
;;
;;   (define-prefix-command 'git-tools)
;;   (global-set-key "\C-cg" 'git-tools)
;;   (global-set-key "\C-cgs" 'magit-status)
;;   (global-set-key "\C-cgc" 'git-insert-credit)
;;   (global-set-key "\C-cgb" 'git-blame-mode)
;;   (global-set-key "\C-cgl" 'git-show-current-commit)

(defun git-contributors ()
  "Return the list of git contributors for the current repository"
  (let ((contributors-string
         (shell-command-to-string
          "git log -300 --pretty=format:'%an <%ae>%n%cn <%ce>' | sort -u")))
    (split-string contributors-string "[\n\r]+" t)))

(defun git-read-contributor (prompt)
  "Read the name and e-mail of a git contributor"
  (completing-read prompt (git-contributors)))

(defconst git-credit-headers
  '("Paired-with" "Reviewed-by" "Acked-by" "Tested-by" "Signed-off-by" "Cc"))

(defun git-insert-credit ()
  "Insert a credit line in a git commit message"
  (interactive)
  (let ((completion-ignore-case t))
    (let ((type (completing-read "Credit type: " git-credit-headers))
          (contributor (git-read-contributor "Contributor: ")))
      (insert-string (concat type ": " contributor)))))

;; Requires git/contrib/emacs/git-blame.el and magit
(defun git-show-current-commit ()
  "Show the log message for the current commit"
  (interactive)
  (let ((commit
         (condition-case nil
             (git-blame-current-commit)
           (error
            (message "Turn on git-blame-mode to get commit information")
            nil))))
    (when commit
      (magit-show-commit commit))))
