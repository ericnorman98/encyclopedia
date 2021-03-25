;;; publish.el --- Publishing script -*- lexical-binding: t; -*-

(add-to-list 'load-path ".")

(require 'package)
(package-initialize)

;; (setq package-archives '(("melpa" . "https://melpa.org/packages/")
;;                           ("org" . "http://orgmode.org/elpa/")))

;; (package-refresh-contents)

(package-install 'htmlize)
(package-install 'org-roam)
(package-install 's)

(require 'ox)
(require 'ox-publish)
(require 'ox-html)
(require 'htmlize)
(require 'org-roam)
(require 's)
(require 'encyclopedia)

(setq make-backup-files nil)

;;;;;;;;;;;;;;;;;
;; org-publish ;;
;;;;;;;;;;;;;;;;;


(setq encyclopedia-theme-current 'dark)
(setq encyclopedia-publish-url "https://ericnorman.net")
(setq encyclopedia-publish-sitemap-title "Eric's Encyclopedia")


(setq org-confirm-babel-evaluate nil)
(org-babel-do-load-languages
 'org-babel-load-languages '((python . t)
                             (jupyter . t)))

(defun ericnorman/configure (publish-dir)
  (encyclopedia-publish-configure publish-dir)

  ;; this is important - otherwise org-roam--org-roam-file-p doesnt work.
  (setq org-roam-directory encyclopedia-root-path)
  (setq org-roam-db-location "/home/eric/.emacs.d/.local/etc/org-roam.db"))


(defun ericnorman/publish ()
  (ericnorman/configure "/var/www/ericnorman")

  (rassq-delete-all 'html-mode auto-mode-alist)
  (rassq-delete-all 'web-mode auto-mode-alist)
  (fset 'web-mode (symbol-function 'fundamental-mode))
  (call-interactively 'org-publish-all))


(defun ericnorman/republish ()
  (ericnorman/configure "/var/www/ericnorman")

  (let ((current-prefix-arg 4))
    (rassq-delete-all 'web-mode auto-mode-alist)
    (fset 'web-mode (symbol-function 'fundamental-mode))
    (call-interactively 'org-publish-all)))

(setq org-roam-title-to-slug-function 'encyclopedia-document-title-to-slug)
