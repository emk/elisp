;;;;; Operating-System-Specific Customizations

;; Customizations for Carbon Emacs on MacOS X.
(when (eq system-type 'darwin)
  ;; Taken from http://www.emacswiki.org/cgi-bin/wiki/MacOSTweaks .
  (defun jfb-set-mac-font (name size)
    (interactive
     (list (completing-read "font-name: "
                            (mapcar (lambda (p) (list (car p) (car p)))
                                    (x-font-family-list)) nil t)
           (read-number "size: " 12)))
    (set-face-attribute 'default nil 
                        :family name
                        :slant  'normal
                        :weight 'normal
                        :width  'normal
                        :height (* 10 size)))
  
  (tool-bar-mode 0) ;; The toolbar is useless.
  (setq mac-allow-anti-aliasing t) ;; or nil
  (jfb-set-mac-font "monaco" 13)

  ;; Bind the fn key as Super.  Sadly, the right Command and Option keys
  ;; aren't visible as unique keys to Carbon Emacs, though Parallels can
  ;; see them without any trouble.  Anybody want to patch Carbon Emacs?
  (setq mac-function-modifier 'super)

  ;; Make the keyboard menu work.  I think this has been fixed upstream.
  ;; http://groups.google.com/group/carbon-emacs/browse_thread/thread/b51921f9644b954c
  (when (condition-case nil
            (symbol-function mac-input-method-mode)
          (error nil))
    (mac-input-method-mode 1)))

;; On Windows, always assume that we have Cygwin.
;;
;; This was adapted, in part, from some Emacs Cygwin
;; documentation somewhere.
;;
;; When running in a Parallels VM, you need to do a number of things get a
;; reasonable keyboard setup.  I recommend the following:
;;
;;   1) Disable Command-ZXCVAF remapping in the Parallels preference
;;      dialog.
;;   2) Use SharpKeys to reverse Left-Alt and Left-Windows.
;;   3) Use the Mac's Keyboard & Mouse control panel to change the shortcut
;;      for "Quit Parallels Desktop" to something other than Command-Q.
;;      See http://forum.parallels.com/thread15835.html for details.
(when (or (eq system-type 'windows-nt)
          (eq system-type 'cygwin))
  ;; I always install Cygwin in Unix mode.
  (setq default-buffer-file-coding-system 'unix)

  ;; This assumes that Cygwin is installed in C:\cygwin (the
  ;; default) and that C:\cygwin\bin is not already in your
  ;; Windows Path (it generally should not be).
  (setq exec-path (cons "C:/cygwin/bin" exec-path))
  (setenv "PATH" (concat "C:\\cygwin\\bin;" (getenv "PATH")))
  
  ;; NT-emacs assumes a Windows command shell, which you change
  ;; here.
  (setq process-coding-system-alist '(("bash" . undecided-unix)))
  (setq shell-file-name "bash")
  (setenv "SHELL" shell-file-name) 
  (setq explicit-shell-file-name shell-file-name) 

  ;; This removes unsightly ^M characters that would otherwise
  ;; appear in the output of java applications.
  (add-hook 'comint-output-filter-functions
            'comint-strip-ctrl-m)

  ;; Map the Windows menu key to Super.
  (setq w32-apps-modifier 'super)

  ;; Add support for Cygwin-style pathnames.
  (require 'cygwin-mount)
  (cygwin-mount-activate))
