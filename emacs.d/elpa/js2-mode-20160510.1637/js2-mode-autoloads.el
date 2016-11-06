;;; js2-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (js2-imenu-extras-mode js2-imenu-extras-setup)
;;;;;;  "js2-imenu-extras" "js2-imenu-extras.el" (22325 54038 425793
;;;;;;  836000))
;;; Generated autoloads from js2-imenu-extras.el

(autoload 'js2-imenu-extras-setup "js2-imenu-extras" "\


\(fn)" nil nil)

(autoload 'js2-imenu-extras-mode "js2-imenu-extras" "\
Toggle Imenu support for frameworks and structural patterns.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (js2-jsx-mode js2-mode js2-minor-mode js2-highlight-unused-variables-mode)
;;;;;;  "js2-mode" "js2-mode.el" (22325 54038 453793 836000))
;;; Generated autoloads from js2-mode.el

(autoload 'js2-highlight-unused-variables-mode "js2-mode" "\
Toggle highlight of unused variables.

\(fn &optional ARG)" t nil)

(autoload 'js2-minor-mode "js2-mode" "\
Minor mode for running js2 as a background linter.
This allows you to use a different major mode for JavaScript editing,
such as `js-mode', while retaining the asynchronous error/warning
highlighting features of `js2-mode'.

\(fn &optional ARG)" t nil)

(autoload 'js2-mode "js2-mode" "\
Major mode for editing JavaScript code.

\(fn)" t nil)

(autoload 'js2-jsx-mode "js2-mode" "\
Major mode for editing JSX code.

To customize the indentation for this mode, set the SGML offset
variables (`sgml-basic-offset' et al) locally, like so:

  (defun set-jsx-indentation ()
    (setq-local sgml-basic-offset js2-basic-offset))
  (add-hook 'js2-jsx-mode-hook #'set-jsx-indentation)

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("js2-mode-pkg.el" "js2-old-indent.el")
;;;;;;  (22325 54038 475445 553000))

;;;***

(provide 'js2-mode-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; js2-mode-autoloads.el ends here
