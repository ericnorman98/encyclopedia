;;; publish.el --- Publishing script -*- lexical-binding: t; -*-

(add-to-list 'load-path ".")

(require 'package)
(package-initialize)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("org" . "http://orgmode.org/elpa/")))

(package-refresh-contents)

(package-install 'htmlize)
(package-install 'org-roam)
(package-install 's)

(require 'ox)
(require 'ox-publish)
(require 'ox-html)
(require 'htmlize)
(require 'org-roam)
(require 's)
(require 'ericnorman)

(setq make-backup-files nil)

;;;;;;;;;;;;;;;;;
;; org-publish ;;
;;;;;;;;;;;;;;;;;


(setq ericnorman/current-color-theme "dark")

(setq ericnorman/publish-url "https://ericnorman.net")

(setq ericnorman/preamble "
<div id=\"org-div-home-and-up\">
<div class=\"intro\">
<a href=\"/\">
  <img class=\"profile\" src=\"/images/profile.jpg\" alt=\"Me\"/>
</a>
<div>
</div>
")

(setq ericnorman/postamble "<p>POSTAMBLE</p>")

(setq ericnorman/head-extra (concat "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/main.css\">"
                                    "<link rel=\"icon\" type=\"image/png\" href=\"/images/icon.png\" />"))

(setq org-confirm-babel-evaluate nil)
(org-babel-do-load-languages
 'org-babel-load-languages '((python . t)))
(org-babel-lob-ingest "~/org/pyorg/pyorg.org")

(defun ericnorman/get-tags-test ()
  (message (concat (mapconcat #'identity (ericnorman/get-tags "~/blog/20210220093951-traveling_waves.org") " "))))

(defun ericnorman/get-tags (file)
  (with-temp-buffer
    (insert-file-contents file)
    (org-roam--extract-tags)))

(defun ericnorman/sitemap-format-entry (entry _style project)
  "Return string for each ENTRY in PROJECT."
  (let* ((title (org-publish-find-title entry project))
         (slug (ericnorman/org-roam-title-to-slug title))
         (thumb (format "%s.png" slug)))
    (if (file-exists-p thumb)
        (concat "@@html:<div class=\"sitemap-item\">@@\n"
                "@@html:<div class=\"sitemap-item-thumb\">@@\n"
                "[[file:"thumb"]]\n"
                "@@html:</div>@@\n"
                "@@html:<div class=\"sitemap-item-content\">@@\n"
                "[[file:"entry"]["title"]]\n"
                "@@html:<div class=\"sitemap-date\">@@\n"
                (format-time-string "%d %h %Y"
                                    (org-publish-find-date entry project))
                "@@html:</div>@@\n"
                (mapconcat (lambda (tag)
                             (format "@@html:<span class=\"tag badge\">@@%s@@html:</span>@@" tag)) (ericnorman/get-tags entry) "")
                "@@html:</div>@@\n"
                "@@html:</div>@@\n")
      "")))



(defun ericnorman/sitemap-function (title list)
  (concat "#+title: " title "\n\n"
          "\n#+begin_sitemap\n\n"
          (mapconcat (lambda (li)
                       (format "%s" (car li)))
                     (seq-filter #'car (cdr list))
                     "")
          "\n#+end_sitemap\n"))


(defun ericnorman/configure (project-dir publish-dir)
  (setq ericnorman/project-dir project-dir)
  (ericnorman/configure-org-publish project-dir publish-dir)

  ;; this is important - otherwise org-roam--org-roam-file-p doesnt work.
  (setq org-roam-directory project-dir)
  (setq org-roam-db-location "/home/eric/.emacs.d/.local/etc/org-roam.db"))


(defun ericnorman/configure-local ()
  (interactive)
  (ericnorman/configure "/home/eric/blog" "/var/www/ericnorman"))


(defun ericnorman/publish ()
  (ericnorman/configure "/home/eric/blog" "/var/www/ericnorman")

  (rassq-delete-all 'html-mode auto-mode-alist)
  (rassq-delete-all 'web-mode auto-mode-alist)
  (fset 'web-mode (symbol-function 'fundamental-mode))
  (call-interactively 'org-publish-all))


(defun ericnorman/republish ()
  (ericnorman/configure "/home/eric/blog" "/var/www/ericnorman")

	(let ((current-prefix-arg 4))
    (rassq-delete-all 'web-mode auto-mode-alist)
    (fset 'web-mode (symbol-function 'fundamental-mode))
    (call-interactively 'org-publish-all)))


(defun ericnorman/configure-org-publish (project-dir publish-dir)
  (setq org-export-with-toc nil
        org-export-with-author t
        org-export-with-email nil
        org-export-with-creator nil
        org-export-with-section-numbers nil

        org-html-scripts (concat org-html-scripts)
        ;; org-html-head ericnorman/head-extra

        org-html-postamble "<p class=\"postamble\">Last Updated %C.</p>"

        org-publish-project-alist
        `(("ericnorman"
           :components ("ericnorman-notes" "ericnorman-static"))
          ("ericnorman-notes"
           :base-directory ,project-dir
           :base-extension "org"
           :exclude "index.org\\|setup.org"
           :publishing-directory ,publish-dir
           :publishing-function org-html-publish-to-html
           :recursive t
           :headline-levels 4
           :with-toc nil
           :html-doctype "html5"
           :html-html5-fancy t
           :html-preamble ,ericnorman/preamble
           ;; :html-postamble ,ericnorman/postamble
           :html-head-include-scripts nil
           :html-head-include-default-style nil
           :html-head-extra ,ericnorman/head-extra
           :html-container "section"
           :htmlized-source nil
           :auto-sitemap t
           :exclude "node_modules"
           :sitemap-title "Eric's Encyclopedia"
           :sitemap-sort-files anti-chronologically
           :sitemap-format-entry ericnorman/sitemap-format-entry
           :sitemap-filename "index.org"
           :sitemap-function ericnorman/sitemap-function
           )
          ("ericnorman-static"
           :base-directory ,project-dir
           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|svg\\|svg\\|json\\|pdf"
           :publishing-directory ,publish-dir
           :exclude "node_modules"
           :recursive t
           :publishing-function org-publish-attachment))))


(defun ericnorman/org-roam-title-to-slug (title)
  "Convert TITLE to a filename-suitable slug.  Use hyphens rather than underscores."
  (cl-flet* ((nonspacing-mark-p (char)
                                (eq 'Mn (get-char-code-property char 'general-category)))
             (strip-nonspacing-marks (s)
                                     (apply #'string (seq-remove #'nonspacing-mark-p
                                                                 (ucs-normalize-NFD-string s))))
             (cl-replace (title pair)
                         (replace-regexp-in-string (car pair) (cdr pair) title)))
    (let* ((pairs `(("[^[:alnum:][:digit:]]" . "_")  ;; convert anything not alphanumeric
                    ("__*" . "_")  ;; remove sequential underscores
                    ("^_" . "")  ;; remove starting underscore
                    ("_$" . "")))  ;; remove ending underscore
           (slug (-reduce-from #'cl-replace (strip-nonspacing-marks title) pairs)))
      (downcase slug))))

(setq org-roam-title-to-slug-function 'ericnorman/org-roam-title-to-slug)


(defun ericnorman/org-roam--backlinks-list (file)
  (if (org-roam--org-roam-file-p file)
      (--reduce-from
       (concat acc (format "- [[file:%s][%s]]\n"
                           (file-relative-name (car it) org-roam-directory)
                           (org-roam-db--get-title (car it))))
       "" (org-roam-db-query [:select [source] :from links :where (= dest $s1)] file))
    ""))


(defun ericnorman/org-export-preprocessor (backend)
  (let ((links (ericnorman/org-roam--backlinks-list (buffer-file-name))))
    (unless (string= links "")
      (save-excursion
        (goto-char (point-max))
        (insert (concat "\n* Backlinks\n") links)))))

(add-hook 'org-export-before-processing-hook 'ericnorman/org-export-preprocessor)

(setq org-roam-graph-exclude-matcher '("sitemap" "index" "recentchanges"))

(defun ericnorman/org-roam-graph ()
  (org-roam-graph))

