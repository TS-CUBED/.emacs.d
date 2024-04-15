;; init-markdown.el --- Initialize markdown configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2024 Torsten Schenkel

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;

;;; Commentary:
;;
;; Quarto configurations.
;;

;;; Code:

(use-package quarto-mode
  :mode (("\\.qmd" . poly-quarto-mode))
  :init
  (setq markdown-enable-wiki-links t
        markdown-italic-underscore t
        markdown-asymmetric-header t
        markdown-make-gfm-checkboxes-buttons t
        markdown-gfm-uppercase-checkbox t
        markdown-fontify-code-blocks-natively t)
  :config
  ;; (add-hook 'poly-quarto-mode-hook 'variable-pitch-mode)
  ;; (add-hook 'poly-quarto-mode-hook 'company-posframe-mode t)
  (add-hook 'poly-quarto-mode-hook 'visual-line-mode)
  (add-hook 'poly-quarto-mode-hook 'olivetti-mode)
  (add-hook 'poly-quarto-mode-hook 'texfrag-mode)
  ;; (add-hook 'poly-quarto-mode-hook 'buffer-face-mode)

  (defun async-shell-command-no-window
      (command)
    (interactive)
    (let
        ((display-buffer-alist
          (list
           (cons
            "\\*Async Shell Command\\*.*"
            (cons #'display-buffer-no-window nil)))))
      (async-shell-command
       command)))

  (defun my/quarto-preview ()
    "Send current buffer file to quarto-preview."
    (interactive)
    (async-shell-command (concat "quarto preview " (shell-quote-argument (buffer-file-name)))))

  (defun my/quarto-project-preview ()
    "Send current buffer file to quarto-preview."
    (interactive)
    (async-shell-command (concat "quarto preview " (shell-quote-argument (file-name-directory buffer-file-name)))))

  (defun my/quarto-render ()
    "Send current buffer file to quarto-preview."
    (interactive)
    (async-shell-command-no-window (concat "quarto render " (shell-quote-argument (buffer-file-name)))))

  (defun my/quarto-project-render ()
    "Send current buffer file to quarto-preview."
    (interactive)
    (async-shell-command-no-window (concat "quarto render " (shell-quote-argument (file-name-directory buffer-file-name)))))
  (which-key-add-key-based-replacements "C-c q" "quarto")
  :bind (("C-c q q" . my/quarto-render)
         ("C-c q p" . my/quarto-preview)
         ("C-c q Q" . my/quarto-project-render)
         ("C-c q P" . my/quarto-project-preview))
  )

(provide 'init-quarto-ts)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-markdown.el ends here
