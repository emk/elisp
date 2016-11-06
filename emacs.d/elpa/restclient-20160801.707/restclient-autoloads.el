;;; restclient-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (restclient-mode restclient-http-send-current-stay-in-window
;;;;;;  restclient-http-send-current-raw restclient-http-send-current)
;;;;;;  "restclient" "restclient.el" (22472 52345 648525 16000))
;;; Generated autoloads from restclient.el

(autoload 'restclient-http-send-current "restclient" "\
Sends current request.
Optional argument RAW don't reformat response if t.
Optional argument STAY-IN-WINDOW do not move focus to response buffer if t.

\(fn &optional RAW STAY-IN-WINDOW)" t nil)

(autoload 'restclient-http-send-current-raw "restclient" "\
Sends current request and get raw result (no reformatting or syntax highlight of XML, JSON or images).

\(fn)" t nil)

(autoload 'restclient-http-send-current-stay-in-window "restclient" "\
Send current request and keep focus in request window.

\(fn)" t nil)

(autoload 'restclient-mode "restclient" "\
Turn on restclient mode.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("restclient-pkg.el") (22472 52345 661465
;;;;;;  170000))

;;;***

(provide 'restclient-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; restclient-autoloads.el ends here
