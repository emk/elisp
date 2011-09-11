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

(defun find-todo ()
  "Find today's todo file, creating it if necessary."
  (interactive)
  (let ((path (format-time-string "~/doc/todo/%Y%m%d.txt")))
    (find-file path)))

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
