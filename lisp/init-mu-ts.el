;; init-mu.el --- Initialize mu4e configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2019-2020 Vincent Zhang

;; Author: Vincent Zhang <seagle0128@gmail.com>
;; URL: https://github.com/seagle0128/.emacs.d

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

;;; Commentary:
;;
;; Mu for Emacs.
;;

;;; Code:

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e/")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu/mu4e/")

(use-package mu4e
  ;; :straight (:type built-in)

  :commands mu4e
  :bind (("C-c o m" . mu4e))
  :config
  (setq mu4e-get-mail-command "mbsync -a" )
  ;;rename files when moving
  ;;NEEDED FOR MBSYNC
  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-update-interval 300)
  (setq mu4e-maildir "~/.mail")

  ;; "needed for calendar accept"
  (setq mu4e-view-use-gnus t)
  ;;  (require 'mu4e-icalendar)
  ;;  (mu4e-icalendar-setup)

  (setq mu4e-contexts
        `( ,(make-mu4e-context
             :name "Private"
             :enter-func (lambda () (mu4e-message "Entering Private context"))
             :leave-func (lambda () (mu4e-message "Leaving Private context"))
             ;; we match based on the contact-fields of the message
             :match-func (lambda (msg)
                           (when msg
                             (string-match-p "^/T-CUBED" (mu4e-message-field msg :maildir))))
             :vars '( ( user-mail-address	    . "torsten@t-cubed.org.uk"  )
                      ( user-full-name	    . "Torsten Schenkel" )
                      ( message-user-organization . "T-CUBED" )
                      (mu4e-drafts-folder . "/T-CUBED/Drafts")
                      (mu4e-sent-folder   . "/T-CUBED/Sent")
                      (mu4e-trash-folder  . "/T-CUBED/Trash")
                      (mu4e-refile-folder . "/T-CUBED/Archive")
                      (mu4e-maildir-shortcuts . (("/T-CUBED/INBOX" . ?i)
                                                 ("/T-CUBED/Sent"  . ?s)
                                                 ("/T-CUBED/Archive"  . ?a)
                                                 ("/T-CUBED/Trash"  . ?t)))
                      ( mu4e-compose-reply-to-address . "t.schenkel@t-cubed.org.uk" )
                      ( user-mail-address . "t.schenkel@t-cubed.org.uk" )
                      ( user-full-name  . "Torsten Schenkel" )
                      ( smtpmail-default-smtp-server . "smtp.strato.de" )
                      ( smtpmail-smtp-server . "smtp.strato.de" )
                      ( smtpmail-smtp-service . 25 )
                      ( smtpmail-smtp-user "torsten@t-cubed.org.uk")
                      ( smtpmail-stream-type . starttls )
                      ( smtpmail-local-domain . "t-cubed.org.uk" )
                      ( mu4e-compose-signature .
                        (concat
                         "Torsten Schenkel\n"
                         "Sheffield, UK\n"))))
           ,(make-mu4e-context
             :name "Work"
             :enter-func (lambda () (mu4e-message "Switch to the Work context"))
             :leave-func (lambda () (mu4e-message "Leaving Work context"))
             ;; no leave-func
             ;; we match based on the maildir of the message
             ;; this matches maildir /Arkham and its sub-directories
             :match-func (lambda (msg)
                           (when msg
                             (string-match-p "^/SHU" (mu4e-message-field msg :maildir))))
             :vars '( ( user-mail-address	       . "t.schenkel@shu.ac.uk" )
                      ( user-full-name	       . "Dr Torsten Schenkel" )
                      ( message-user-organization . "Sheffield Hallam University" )
                      (mu4e-drafts-folder . "/SHU/Drafts")
                      (mu4e-sent-folder   . "/SHU/Sent")
                      (mu4e-trash-folder  . "/SHU/Trash")
                      (mu4e-refile-folder . "/SHU/Archive")
                      (mu4e-maildir-shortcuts . (("/SHU/INBOX" . ?i)
                                                 ("/SHU/Sent"  . ?s)
                                                 ("/SHU/Archive"  . ?a)
                                                 ("/SHU/Trash"  . ?t)))
                      ( mu4e-compose-reply-to-address . "t.schenkel@shu.ac.uk" )
                      ( user-mail-address . "acests3@hallam.shu.ac.uk" )
                      ( user-full-name  . "Torsten Schenkel" )
                      ;; ( smtpmail-default-smtp-server . "davmail" )
                      ( smtpmail-smtp-server . "localhost" )
                      ( smtpmail-smtp-service . 1025 )
                      ( smtpmail-smtp-user "acests3@hallam.shu.ac.uk" )
                      ( smtpmail-stream-type . nil )
                      ;; ( smtpmail-default   -smtp-server . "smtp.office365.com" )
                      ;; ( smtpmail-smtp-server . "smtp.office365.com" )
                      ( smtpmail-local-domain . "shu.ac.uk" )
                      ( mu4e-compose-signature .
                        (concat
                         "Dr Torsten Schenkel\n"
                         "Dr.-Ing. habil. CEng FIMechE\n\n"

                         "Associate Professor of Continuum Mechanics\n\n"

                         "Sheffield Hallam University\n"
                         "Department of Engineering and Mathematics\n"
                         "College of Business, Technology and Engineering\n"
                         "Room 4206, Sheaf Building\n\n"

                         "Sheffield, S1 1WB\n"
                         "UK\n\n"

                         "Tel:     +44 (0)114 225 6294\n"
                         "https://www.shu.ac.uk/about-us/our-people/staff-profiles/torsten-schenkel\n"
                         "https://blogs.shu.ac.uk/ecm\n"
                         "https://ts-cubed.github.io\n"
                         "https://www.github.com/TS-CUBED"))))))

  ;; don't keep message buffers around
  (setq message-kill-buffer-on-exit t))


;; Notification
(use-package mu4e-alert
  :hook (after-init . mu4e-alert-enable-mode-line-display))

(provide 'init-mu-ts)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-mu.el ends here
