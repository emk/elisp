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
;; working with git.  At some point, I'll package these up and turn them
;; into something real.

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
  '("Paired-with" "Reviewed-by" "Acked-by" "Tested-by"))

(defun git-insert-credit ()
  "Insert a credit line in a git commit message"
  (interactive)
  (let ((type (completing-read "Credit type: " git-credit-headers))
        (contributor (git-read-contributor "Contributor: ")))
    (insert-string (concat type ": " contributor))))

;; Requires git/contrib/emacs/git-blame.el
(defun git-show-current-commit ()
  "Show the log message for the current commit"
  (interactive)
  (magit-show-commit (git-blame-current-commit)))
