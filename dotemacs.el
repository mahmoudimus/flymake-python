;; add this to your .emacs file:

;; load flymake lint runner
(when (load "flymake" t)
  (defun flymake-python-lint-init (&optional trigger-type)
    ;; (print virtualenv-workon (get-buffer "*Messages*"))
    ;; (print virtualenv-root (get-buffer "*Messages*"))
    ;; (print buffer-file-name (get-buffer "*Messages*"))
    ;; (print file-local-variables-alist (get-buffer "*Messages*"))
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name)))
           (venv-path (concat virtualenv-root "/" virtualenv-workon))
           (options (when trigger-type (list "--trigger-type" trigger-type))))
      (if (and virtualenv-workon (not (string= virtualenv-workon " Virtualenv")))
          (if (listp options)
              (progn (push (concat "--virtualenv=" venv-path) options))
            (let (options (list (concat "--virtualenv=" venv-path))))))
      (list (concat (getenv "HOME") "/bin/flymake-python/pyflymake.py") (append options (list local-file)))))

  (add-to-list 'flymake-allowed-file-name-masks '("\\.py\\'" flymake-python-lint-init)))
