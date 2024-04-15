;; init-python-ts.el --- Initialize python configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2010-2024 Vincent Zhang

;; Author: Vincent Zhang <seagle0128@gmail.com>
;; URL: https://github.com/seagle0128/.emacs.d

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
;; Julia configurations.
;;

;;; Code:


;; see Julia manual for the detailed description of this var
(setenv "JULIA_NUM_THREADS" "auto")

(defun my/julia-snail-send-cell()
  ;; "Send the current julia cell (delimited by ## or a fenced block) to the julia shell"
  (interactive)
  (save-excursion (setq cell-begin (if (re-search-backward "\\(^##\\|^```\\)" nil t)
                                       (point)
                                     nil)))
  (save-excursion (setq cell-end (if (re-search-forward "\\(^##\\|^```\\)" nil t)
                                     (point)
                                   nil)))
  (goto-char cell-begin)
  (next-line)
  (beginning-of-line)
  (set-mark (point))
  (goto-char cell-end)
  (previous-line)
  (end-of-line)
  (julia-snail-send-region)
  (next-line)
  (next-line)
  )

(use-package julia-snail
  :defer t
  :hook (julia-mode . julia-snail-mode)
  :init
  (setq julia-snail-repl-display-eval-results nil)
  (setq julia-snail-multimedia-enable t)
  ;; (julia-snail-multimedia-toggle-display-in-emacs)
  (customize-set-variable 'split-height-threshold 15)
  (setq julia-snail-multimedia-buffer-style :multi)
  (setq julia-snail/ob-julia-mirror-output-in-repl t)
  :bind (("C-c o j" . julia-snail))
  :config
  (define-key julia-snail-mode-map (kbd "<M-RET>") (lambda() (interactive) (julia-snail-send-line) (next-line)))
  (define-key julia-snail-mode-map (kbd "C-M-<return>") 'my/julia-snail-send-cell)
  (add-to-list 'display-buffer-alist
               '("\\*julia" (display-buffer-reuse-window display-buffer-same-window)))
  )

(use-package eglot-jl
  :after eglot
  :preface
  :init
  ;; Prevent auto-install of LanguageServer.jl
  ;; (setq eglot-jl-language-server-project "~/.julia/environments/languageserver")
  ;; Prevent timeout while installing LanguageServer.jl
  (setq eglot-connect-timeout 300)
  (add-hook 'julia-mode-hook eglot-connect-timeout (max eglot-connect-timeout 300))
  :config (eglot-jl-init))

;; (use-package! lsp-julia
;;               :init
;;               (setq lsp-julia-package-dir nil)
;;               (setq lsp-julia-flags '("--project=~/.julia/environments/languageserver" "--startup-file=no" "--history-file=no"))
;;               (setq lsp-julia-default-environment "~/.julia/environment/languageserver")
;;               )


(provide 'init-julia-ts)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-python.el ends here
