;; init-denote-ts.el --- Initialize denote configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2024 Torsten Schenkel

;; Author: Torsten Schenkel
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
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

(use-package denote
  :bind (("C-c n d b" . my/denote-toggle-backlinks)
         ("C-c n d f" . denote-open-or-create)
         ("C-c n d g" . counsel-rg)
         ("C-c n d l" . denote-link-or-create)
         ("C-c n d n" . denote-create-note-using-type)
         ("C-c n d j" . my-denote-journal))
  :config
  (setq denote-directory (expand-file-name "~/Documents/Denote"))

  (add-to-list 'denote-file-types '(markdown-quarto :extension ".qmd"
                                                    :date-function denote-date-rfc3339
                                                    :front-matter denote-quarto-front-matter
                                                    :title-key-regexp "^title\\s-*:"
                                                    :title-value-function denote-surround-with-quotes
                                                    :title-value-reverse-function denote-trim-whitespace-then-quotes
                                                    :keywords-key-regexp "^tags\\s-*:"
                                                    :keywords-value-function denote-format-keywords-for-md-front-matter
                                                    :keywords-value-reverse-function denote-extract-keywords-from-front-matter
                                                    :link denote-md-link-format
                                                    :link-in-context-regexp denote-md-link-in-context-regexp))
  (setq denote-quarto-front-matter
        "---
title:      %1$s
author:     Torsten Schenkel
date:       %2$s
filetags:   %3$s
identifier: %4$s

date-format: long
cap-location: margin
reference-location: margin
papersize: a4
citation-location: margin
bibliography: library.bib

execute:
  cache: true
---\n\n")
  ;; (map!
  ;;  :leader
  ;;  (:prefix ("n" . "notes")
  ;;   "d" . nil))

  ;; (map!
  ;;  :leader
  ;;  (:prefix ("n" . "notes")
  ;;   (:prefix ("d" . "denote")
  ;;    "b" #'my/denote-toggle-backlinks
  ;;    "d" #'notdeft
  ;;    "g" #'counsel-rg
  ;;    "f" #'denote-open-or-create
  ;;    "j" #'my-denote-journal
  ;;    "l" #'denote-link-or-create
  ;;    "n" #'denote-create-note-using-type
  ;;    "r" #'denote-rename-file
  ;;    "x" #'xeft
  ;;    (:prefix ("k" . "keywords")
  ;;     "a" #'denote-keywords-add
  ;;     "r" #'denote-keywords-remove))))

  (setq denote-link-backlinks-display-buffer-action
        '((display-buffer-reuse-window
           display-buffer-in-side-window)
          (side . right)
          (slot . 99)
          (window-width . 0.25)))
  (add-hook 'denote-backlinks-mode-hook '+word-wrap-mode)
  ;; (add-hook 'org-mode-hook 'denote-link-backlinks)
  )

(defun first-file-with-substring (dir substring)
  "Return the first file in DIR containing SUBSTRING.
Return nil if there is no files with SUBSTRING in its name."
  (let ((files (file-expand-wildcards (concat dir "*" substring "*"))))
    (when (>= (length files) 1)
      (car files))))

(defun my-denote-journal (&optional date-prompt)
  "Add or modify today's journal entry.

With prefix arg of if DATE-PROMPT is non-nil, prompt for a date."
  (interactive "P")
  (let* ((denote-directory (expand-file-name "journal" denote-directory))  ; I don't keep them in the same place as my other notes.
         (denote-file-type 'org)
         (time (org-read-date nil t))
         (title (format-time-string "%A %-d %B %Y" time))
         (file-name-string (concat (replace-regexp-in-string " " "-" (downcase title)) "__journal"))
         (existing-journal-entry (first-file-with-substring (denote-directory) file-name-string)))
    (if existing-journal-entry
        (find-file existing-journal-entry)
      (denote title '("journal")))))

(defun my/denote-refresh-backlinks ()
  (interactive)
  (if (derived-mode-p 'org-mode)
      (if (equal (file-name-directory buffer-file-name) (denote-directory))
          (denote-link-backlinks)))
  (if (derived-mode-p 'markdown-mode)
      (if (equal (file-name-directory buffer-file-name) (denote-directory))
          (denote-link-backlinks))))

(defun my/denote-kill-backlinks-buffers ()
  (interactive)
  (remove-hook 'doom-switch-window-hook 'my/denote-refresh-backlinks)
  (remove-hook 'doom-switch-buffer-hook 'my/denote-refresh-backlinks)
  (cl-loop for buffer in (buffer-list)
           do (if (string-prefix-p "*denote-backlinks" (buffer-name buffer))
                  (kill-buffer buffer))))

(setq denote-backlinks-toggle nil)
(defun my/denote-toggle-backlinks ()
  (interactive)
  (if denote-backlinks-toggle
      (progn (my/denote-kill-backlinks-buffers)
             (setq denote-backlinks-toggle nil))
    (progn (add-hook 'doom-switch-window-hook 'my/denote-refresh-backlinks)
           (add-hook 'doom-switch-buffer-hook 'my/denote-refresh-backlinks)
           (my/denote-refresh-backlinks)
           (setq denote-backlinks-toggle t))))

(provide 'init-denote-ts)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-denote-ts.el ends here
