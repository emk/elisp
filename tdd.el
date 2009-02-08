;;; tdd.el - Some tools to make the rhythm of test-driven design faster.
;;; Unreleased proof-of-Concept version, 01 Jun 2003.


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
(global-set-key [?\s-5] (select:make-raw-switch-command "\\`TODO"))
