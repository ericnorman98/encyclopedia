;;; publish.el --- Publishing script -*- lexical-binding: t; -*-

(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'package)

(setq package-user-dir (expand-file-name "~/encyclopedia/.pkgs"))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(use-package htmlize
  :ensure t)

(use-package org-roam
  :ensure t)

(use-package s
  :ensure t)

(use-package jupyter
  :ensure t)

(use-package esxml
  :ensure t)

(require 'ox)
(require 'ox-publish)
(require 'ox-html)
(require 'encyclopedia)

(setq make-backup-files nil)

;;;;;;;;;;;;;;;;;
;; org-publish ;;
;;;;;;;;;;;;;;;;;


(setq encyclopedia-theme-current 'dark)
(setq encyclopedia-publish-url "https://ericnorman.net")
(setq encyclopedia-publish-sitemap-title "Eric's Encyclopedia")


(defun en/configure (publish-dir)
  (encyclopedia-publish-configure publish-dir)

  ;; this is important - otherwise org-roam--org-roam-file-p doesnt work.
  (setq org-roam-directory encyclopedia-root-path)
  (setq org-roam-db-location "/home/eric/.emacs.d/.local/etc/org-roam.db"))


(defun en/publish ()
  (en/configure "/var/www/ericnorman")

  (call-interactively 'org-publish-all))
  ;; (encyclopedia-publish-files "/var/www/ericnorman"))


(defun en/republish ()
  (en/configure "/var/www/ericnorman")

  (let ((current-prefix-arg 4))
    (rassq-delete-all 'web-mode auto-mode-alist)
    (fset 'web-mode (symbol-function 'fundamental-mode))
    (call-interactively 'org-publish-all)))

(setq org-roam-title-to-slug-function 'encyclopedia-document-title-to-slug)
