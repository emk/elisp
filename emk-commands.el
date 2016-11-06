(defun insert-block-comment ()
  "Insert a block comment in a C file"
  (interactive)
  (insert-string (concat "/*=========================================="
			 "===============================\n**  "))
  (let ((title-point (point)))
    (insert-string (concat "\n**=========================================="
			   "===============================\n**  "))
    (let ((description-point (point)))
      (insert-string "\n*/")
      (set-mark description-point)
      (goto-char title-point))))

(defun find-dotemacs ()
  "Open and edit the .emacs configuration file"
  (interactive)
  (find-file "~/w/elisp/dotemacs"))

(defun insert-timestamp-rfc-2822 ()
  "Insert a timestamp at point in RFC 2822 format."
  (interactive)
  ;; http://stackoverflow.com/questions/14074912/how-do-i-delete-the-newline-from-a-process-output
  (insert (replace-regexp-in-string "\n$" ""
                                    (shell-command-to-string "date -R"))))

;;;
;;; Unwrapping lines (adapted from longlines.el by Kai Grossjohann and Alex
;;; Schroeder)
;;;

(defun unwrap-region (start end &optional buffer)
  "Unwrap long lines in the region from START to END.
The region is assumed to contain short lines and soft and hard newlines.
Soft newlines and any following whitespace on the next line will be
replaced with exactly one space.

The optional argument BUFFER will be ignored.  It is assumed to exist
when the function is called via `format-alist'."
  (interactive "r")
  (save-excursion
    (goto-char start)
    (while (re-search-forward "\n[ \t]*" end t)
      (unless (get-text-property (match-beginning 0) 'hard)
        (replace-match " ")))
    (max end (point))))

(defun unwrap-paragraph ()
  "Unwrap all lines in the current paragraph."
  (interactive)
  (save-excursion
    (mark-paragraph)
    ;; I shouldn't really use MARK and POP-MARK in an editing command, but
    ;; that's the only way to get the output of MARK-PARAGRAPH.  Oh, well.
    (unwrap-region (+ (point) 1) (- (mark) 1))
    (pop-mark)))

(defun use-linux-style ()
  "Force the current buffer to use Linux / git indentation conventions"
  (interactive)
  ;; Set up a shell-mode buffer.
  (setq indent-tabs-mode t
        sh-indentation 8
        sh-basic-offset 8
        c-basic-offset 8))

(defun todo-file-p (path)
  "Does this path point to a TODO file?"
  (string-match-p "^[[:digit:]]\\{8\\}\\.txt$" path))

(defun find-todo ()
  "Find today's todo file, creating it if necessary."
  (interactive)
  (let* ((todo-dir "~/doc/todo/")
         (today (concat todo-dir (format-time-string "%Y%m%d.txt"))))
    (find-file today)

    ;; Copy over the most recent TODO list, if any.
    (when (and (string= (buffer-string) "") (not (file-exists-p today)))
      (let ((existing
             (remove-if-not
              'todo-file-p
              (reverse (sort (directory-files todo-dir) 'string<))))
            (previous-text nil))
        (when existing
          (with-current-buffer
              (find-file-noselect (concat todo-dir (car existing)))
            (setq previous-text (buffer-string))
            (kill-buffer))
          (insert previous-text)
          (message (concat "Copied TODO items from " (car existing)))
          (goto-char (point-min)))))))

;; From https://sites.google.com/site/steveyegge2/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
	(progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; From https://sites.google.com/site/steveyegge2/my-dot-emacs-file
(defun move-file-and-buffer (dir)
 "Moves both current buffer and file it's visiting to DIR."
 (interactive "DNew directory: ")
 (let* ((name (buffer-name))
        (filename (buffer-file-name))
        (dir
	 (if (string-match dir "\\(?:/\\|\\\\)$")
             (substring dir 0 -1) dir))
        (newname (concat dir "/" name)))
   (if (not filename)
       (message "Buffer '%s' is not visiting a file!" name)
     (progn
       (copy-file filename newname 1)
       (delete-file filename)
       (set-visited-file-name newname)
       (set-buffer-modified-p nil)
       t))))

;; From http://andrewcoxtech.blogspot.com/2009/11/inserting-bom-into-file.html
(defun insert-bom ()
  "Insert a Unicode Byte Order Mark at the beginning of the buffer."
  (interactive)
  (goto-char (point-min))
  (ucs-insert (string-to-number "FEFF" 16)))

;; From https://github.com/magnars/.emacs.d/blob/master/defuns/lisp-defuns.el
;; This is fun with multiple cursors mode! http://emacsrocks.com/e13.html
(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(defun coq-unicode-cleanup ()
  "Convert pretty Unicode back to correct ASCII characters."
  (interactive)
  (save-excursion
    (proof-goto-end-of-locked)
    (let ((start (point)))
      (mapcar (lambda (r) (replace-string (car r) (cdr r) nil start (point-max)))
              '(("⇒" . "=>")
                ("×" . "*")
                ("→" . "->")
                ("∀" . "forall ")
                ("⇓" . "||"))))))

;;=========================================================================
;; Case utilities
;;
;; Taken from http://www.emacswiki.org/CamelCase.

(defun split-name (s)
  "Split a typical programming language identifier into words."
  (split-string
   (let ((case-fold-search nil))
     (downcase
      (replace-regexp-in-string "\\([a-z]\\)\\([A-Z]\\)" "\\1 \\2" s)))
   "[^A-Za-z0-9]+"))

(defun camelcase  (s)
  "Convert identifier to camelCase."
  ;; TODO - Actually this is AllCapitalized, not camelCase.
  (mapconcat 'capitalize (split-name s) ""))

(defun underscore (s)
  "Convert identifier to use underscores."
  (mapconcat 'downcase (split-name s) "_"))

(defun dasherize (s)
  "Convert identifier to use dashes."
  (mapconcat 'downcase (split-name s) "-"))

(defun colonize (s)
  "Convert identifier to use colons."
  (mapconcat 'capitalize (split-name s) "::"))

(defun pluralize (s)
  "Convert string to English plural."
  (if s
      ;; We'll do better if we need to.
      (concat s "s")
    nil))

(defun singularize (s)
  "Convert string to English singular."
  (if s
      ;; We'll do better if we need to.
      (replace-regexp-in-string "s$" "" s)
    nil))

(defun ember-appkit-type-from-path (path)
  "Convert an appkit path to a class name."
  (let ((components (split-string path "/")))
    (if (= 2 (length components))
        (let ((directory (car components))
              (file (cadr components)))
          (concat (camelcase file)
                  (if (or (string= directory "models")
                          (string= directory "utils"))
                      ""
                    (camelcase (singularize directory)))))
      nil)))

(defun ripgrep-project (shell-args)
  "Run ripgrep over the current Projectile project."
  (interactive "srg: ")
  (require 'projectile)
  (projectile-with-default-dir (projectile-project-root)
    (compile (concat "rg --no-heading " shell-args))))
