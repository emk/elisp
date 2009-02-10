;; tdd.el - Some tools to make the rhythm of test-driven design faster.
;; Copyright 2009 Eric Kidd

;; Author: Eric Kidd <http://www.randomhacks.net/>

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
;;
;; This is still basically proof-of-concept code, and it needs more before
;; anyone else will find it useful.

(defvar *tdd-edit-buffer* nil)
(defvar *tdd-test-buffer* nil)
(defvar *tdd-test-command* nil)

(defun tdd-set-edit-buffer (buffer)
  "Set the name of the source code buffer you're editing while performing
test-driver design.  You can jump to this buffer with \\[tdd-edit-buffer]."
  (interactive "bName of TDD edit buffer: ")
  (setq *tdd-edit-buffer* buffer))

(defun tdd-set-test-buffer (buffer)
  "Set the name of the test suite buffer you're editing while performing
test-driver design.  You can jump to this buffer with \\[tdd-test-buffer]."
  (interactive "bName of TDD test buffer: ")
  (setq *tdd-test-buffer* buffer))

(defun tdd-set-test-command (command)
  "Set the command used to run your test suites.  You can run this
command using \\[tdd-run-tests]."
  (interactive "MCommand to run test suite: ")
  (setq *tdd-test-command* command))

(defun tdd-edit-buffer ()
  "Switch to the buffer you selected with \\[tdd-set-edit-buffer]."
  (interactive)
  (if *tdd-edit-buffer*
    (switch-to-buffer *tdd-edit-buffer*)
    (error "Set TDD edit buffer with \\[tdd-set-edit-buffer] first.")))

(defun tdd-test-buffer ()
  "Switch to the buffer you selected with \\[tdd-set-test-buffer]."
  (interactive)
  (if *tdd-test-buffer*
    (switch-to-buffer *tdd-test-buffer*)
    (error "Set TDD test buffer with \\[tdd-set-test-buffer] first.")))

(defun tdd-run-tests ()
  "Run the command you specified with \\[tdd-set-test-command]."
  (interactive)
  (if *tdd-test-command*
    (compile *tdd-test-command*)
    (error "Set TDD test command with \\[tdd-set-test-command] first.")))

(global-set-key [?\C-\s-1] 'tdd-set-test-buffer)
(global-set-key [?\C-\s-2] 'tdd-set-test-command)
(global-set-key [?\C-\s-3] 'tdd-set-edit-buffer)

(global-set-key [?\s-1] 'tdd-test-buffer)
(global-set-key [?\s-2] 'tdd-run-tests)
(global-set-key [?\s-3] 'tdd-edit-buffer)
(global-set-key [?\s-4] 'delete-other-windows)
