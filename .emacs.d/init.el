;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; quelpa to automatically get packages from sources like github
(unless (package-installed-p 'quelpa)
    (with-temp-buffer
      (url-insert-file-contents "https://github.com/quelpa/quelpa/raw/master/quelpa.el")
      (eval-buffer)
      (quelpa-self-upgrade)))

(defvar myPackages
  '(better-defaults
    helm
    deft
    org-download
    org-journal
    org-roam
    use-package
    markdown-mode
    adoc-mode
    emacsql-sqlite3))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; (quelpa '(hydra :repo "ctonic/org-roam" :fetcher github))

;; BASIC CUSTOMIZATION
;; --------------------------------------
(setq inhibit-startup-message t) ;; hide the startup message
(global-linum-mode t) ;; enable line numbers globally
(menu-bar-mode -1) ;; disable the menu bar
(tool-bar-mode -1) ;; disable the tool bar
(setq visible-bell t) ;; don't make the bell sound

(setq
 backup-by-copying t      ; don't clobber symlinks
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t       ; use versioned backups
 )

(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
(setq auto-save-default nil) ;; auto save makes it laggy

;; Sprache: Deutsch und English
;; ------------------------------
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

;; AUTOMATISCH
;; -------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#ffffff" "#f36c60" "#8bc34a" "#fff59d" "#4dd0e1" "#b39ddb" "#81d4fa" "#263238"))
 '(custom-enabled-themes nil)
 '(fci-rule-color "#37474f")
 '(hl-sexp-background-color "#1c1f26")
 '(package-selected-packages
   (quote
    (adoc-mode emacsql-sqlite3 emacsql-sqlite anaconda-mode jedi langtool auctex ess elpy better-defaults helm)))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#f36c60")
     (40 . "#ff9800")
     (60 . "#fff59d")
     (80 . "#8bc34a")
     (100 . "#81d4fa")
     (120 . "#4dd0e1")
     (140 . "#b39ddb")
     (160 . "#f36c60")
     (180 . "#ff9800")
     (200 . "#fff59d")
     (220 . "#8bc34a")
     (240 . "#81d4fa")
     (260 . "#4dd0e1")
     (280 . "#b39ddb")
     (300 . "#f36c60")
     (320 . "#ff9800")
     (340 . "#fff59d")
     (360 . "#8bc34a"))))
 '(vc-annotate-very-old-color nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Asciidoc
(autoload 'adoc-mode "adoc-mode" nil t)

;; HELM
;; ------------------------------------
(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "C-x r b") 'helm-bookmarks)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)

;; PYTHON
;; -----------------------------------
;; (elpy-enable)
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
(setq indent-tabs-mode nil)

(setq python-shell-interpreter "python3")

;; ======================
;; HERE BE ORG-MODE STUFF
;; ======================
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))
(setq org-startup-folded nil)

;; deft
;; --------------------------------------------
(require 'deft)
(setq deft-directory (substitute-in-file-name "$NOTES"))
(setq deft-extensions '("org" "md" "txt"))
(setq deft-default-extension "org")
(setq deft-use-filename-as-title t)
(setq deft-recursive t)
(setq deft-use-filter-string-for-filename t)
(setq deft-file-naming-rules '((nospace . "-")))
(setq deft-text-mode 'org-mode)
(setq deft-auto-save-interval nil) ;; not auto save please

(global-set-key (kbd "C-c d") 'deft)
(add-hook 'org-mode-hook #'visual-line-mode)

;; org-journal
;; ------------------
(require 'org-journal)
(setq org-journal-dir (substitute-in-file-name "$NOTES/journal"))
(setq org-journal-date-format "%A, %Y-%m-%d")
(setq org-journal-date-prefix "#+TITLE: ")
(setq org-journal-file-format "%Y-%m-%d.org")

;; org-roam
;; ---------------
(use-package org-roam
      :hook 
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory (substitute-in-file-name "$NOTES"))
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n b" . org-roam-switch-to-buffer)
               ("C-c n g" . org-roam-show-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))))

;(require 'org-roam)

; define-key org-roam-mode-map (kbd "C-c n l") 'org-roam)
;(define-key org-roam-mode-map (kbd "C-c n f") 'org-roam-find-file)
;(define-key org-roam-mode-map (kbd "C-c n b") 'org-roam-switch-to-buffer)
;(define-key org-roam-mode-map (kbd "C-c n g") 'org-roam-show-graph)
;(define-key org-mode-map (kbd "C-c n i") 'org-roam-insert)
;(org-roam-mode +1)


;(setq org-roam-directory deft-directory)

;;; org-download
;; --------------------
(require 'org-download)
;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

