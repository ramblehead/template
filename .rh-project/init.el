;; Hey Emacs, this is -*- coding: utf-8 -*-

(require 'blacken)
(require 'cl)
(require 'flycheck)
(require 'hydra)
(require 'lsp-mode)
(require 'lsp-pyright)
(require 'lsp-ruff-lsp)
(require 'vterm)

;;; rh-templates common command
;;; /b/{

(defvar rh-templates/build-buffer-name
  "*rh-templates-build*")

(defun rh-templates/lint ()
  (interactive)
  (rh-project-compile
   "yarn-run app:lint"
   rh-templates/build-buffer-name))

;;; /b/}

;;; rh-templates
;;; /b/{

(defun rh-templates/hydra-define ()
  (defhydra rh-templates-hydra (:color blue :columns 5)
    "@rh-templates workspace commands"
    ("l" rh-templates/lint "lint")))

(rh-templates/hydra-define)

(define-minor-mode rh-templates-mode
  "rh-templates project-specific minor mode."
  :lighter " rh-templates"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "<f9>") #'rh-templates-hydra/body)
            map))

(add-to-list 'rm-blacklist " rh-templates")

(defun rh-templates/lsp-python-deps-providers-path (path)
  (file-name-concat (expand-file-name (rh-project-get-root))
                    ".venv/bin/"
                    path))

(defun rh-templates/lsp-python-init ()
  (plist-put
   lsp-deps-providers
   :rh-templates/local-venv
   (list :path #'rh-templates/lsp-python-deps-providers-path))

  (lsp-dependency 'pyright
                  '(:rh-templates/local-venv "pyright-langserver")))

(eval-after-load 'lsp-pyright #'rh-templates/lsp-python-init)

(defun rh-templates-setup ()
  (when buffer-file-name
    (let ((project-root (rh-project-get-root))
          file-rpath ext-js)
      (when project-root
        (setq file-rpath (expand-file-name buffer-file-name project-root))
        (cond

         ;; Python
         ((or (setq ext-js (string-match-p
                            (concat "\\.py\\'\\|\\.pyi\\'") file-rpath))
              (string-match-p "^#!.*python"
                              (or (save-excursion
                                    (goto-char (point-min))
                                    (thing-at-point 'line t))
                                  "")))

          ;;; /b/; pyright-lsp config
          ;;; /b/{

          (setq-local lsp-pyright-prefer-remote-env nil)
          (setq-local lsp-pyright-python-executable-cmd
                      (file-name-concat project-root ".venv/bin/python"))
          (setq-local lsp-pyright-venv-path
                      (file-name-concat project-root ".venv"))
          ;; (setq-local lsp-pyright-python-executable-cmd "poetry run python")
          ;; (setq-local lsp-pyright-langserver-command-args
          ;;             `(,(file-name-concat project-root ".venv/bin/pyright")
          ;;               "--stdio"))
          ;; (setq-local lsp-pyright-venv-directory
          ;;             (file-name-concat project-root ".venv"))

          ;;; /b/}

          ;;; /b/; ruff-lsp config
          ;;; /b/{

          (setq-local lsp-ruff-lsp-server-command
                      `(,(file-name-concat project-root ".venv/bin/ruff-lsp")))
          (setq-local lsp-ruff-lsp-python-path
                      (file-name-concat project-root ".venv/bin/python"))
          (setq-local lsp-ruff-lsp-ruff-path
                      `[,(file-name-concat project-root ".venv/bin/ruff")])

          ;;; /b/}

          ;;; /b/; Python black
          ;;; /b/{

          (setq-local blacken-executable
                      (file-name-concat project-root ".venv/bin/black"))

          ;;; /b/}

          (setq-local lsp-enabled-clients '(pyright ruff-lsp))
          (setq-local lsp-before-save-edits nil)
          (setq-local lsp-modeline-diagnostics-enable nil)

          (blacken-mode 1)
          (lsp-deferred)))))))

;;; /b/}
