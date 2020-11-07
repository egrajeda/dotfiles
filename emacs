;;; package --- Wut

;;; Commentary:

;;; Code:

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; Custom functions ------------------------------------------------------------

;; https://stackoverflow.com/a/9697222/80979
(defun comment-or-uncomment-region-or-line ()
  "Comment or uncomment the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

;; https://lists.gnu.org/archive/html/emacs-devel/2019-02/msg00289.html
(defun insert-file-name-into-minibuffer (full-path)
  "Insert filename (optionally with the FULL-PATH) into minibuffer."
  (interactive "P")
  (let ((path (buffer-file-name (window-buffer (minibuffer-selected-window)))))
    (insert (if full-path
                path
              (file-name-nondirectory path)))))
(define-key minibuffer-local-map (kbd "M-.") 'insert-file-name-into-minibuffer)

(defun typescript-fix-or-refactor-at-point ()
  "Apply code fix for the error at point, or refactor the code."
  (interactive)
  (if (flycheck-overlay-errors-at (point))
      (tide-fix)
    (tide-refactor)))

;; leuven-theme ----------------------------------------------------------------
;; (use-package leuven-theme
;;   :ensure t
;;   :config
;;   (setq leuven-scale-outline-headlines nil
;;         leuven-scale-org-agenda-structure nil)
;;   (load-theme 'leuven t)
;;   :custom-face
;;   (cursor ((t (:background "#d0372d"))))
;;   (org-document-title ((t (:foreground "#c42c1f" :weight bold :height 1.0))))
;;   (org-document-info-keyword ((t (:foreground "#aaaaaa" :background nil))))
;;   (org-meta-line ((t (:foreground "#aaaaaa"))))
;;   (org-level-1 ((t (:foreground "#222222" :background nil :overline nil :weight bold))))
;;   (org-level-2 ((t (:foreground "#222222" :background nil :overline nil :weight bold))))
;;   (org-level-3 ((t (:foreground "#222222" :background nil :overline nil :weight bold))))
;;   (org-level-4 ((t (:foreground "#222222" :background nil :overline nil :weight bold))))
;;   (org-level-5 ((t (:foreground "#222222" :background nil :overline nil :weight bold))))
;;   (org-block-end-line ((t (:overline nil))))
;;   (org-scheduled-today ((t (:background nil))))
;;   ;; TODO: Is this still needed?
;;   ;; (fringe ((t (:background "#ffffff"))))
;;   )

;; color-theme-sanityinc-tomorrow ----------------------------------------------
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :config
  (load-theme 'sanityinc-tomorrow-night t))

;; auto-package-update.el ------------------------------------------------------
(use-package auto-package-update
  :ensure t)

;; diminish --------------------------------------------------------------------
(use-package diminish
  :ensure t)

;; evil-mode -------------------------------------------------------------------
(use-package evil
  :ensure t
  :init
  ;; These two are needed for evil-collection.
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)

  ;; https://emacs.stackexchange.com/a/13770
  (defun evil-normal-state-or-keyboard-quit ()
    "If in any evil mode other than normal state, force normal state; else run
'keyboard-quit'."
    (interactive)
    (if (and evil-mode (not (eq evil-state 'normal)))
        (evil-force-normal-state)
      (keyboard-quit)))

  (define-key evil-normal-state-map   (kbd "C-g") #'evil-normal-state-or-keyboard-quit)
  (define-key evil-motion-state-map   (kbd "C-g") #'evil-normal-state-or-keyboard-quit)
  (define-key evil-insert-state-map   (kbd "C-g") #'evil-normal-state-or-keyboard-quit)
  (define-key evil-window-map         (kbd "C-g") #'evil-normal-state-or-keyboard-quit)
  (define-key evil-operator-state-map (kbd "C-g") #'evil-normal-state-or-keyboard-quit)

  (define-key evil-normal-state-map   (kbd "C-/") #'comment-or-uncomment-region-or-line)
  (define-key evil-insert-state-map   (kbd "C-/") #'comment-or-uncomment-region-or-line))

;; evil-collection -------------------------------------------------------------
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;; evil-commentary -------------------------------------------------------------
(use-package evil-commentary
  :ensure t
  :config
  (evil-commentary-mode))

;; expand-region ---------------------------------------------------------------
;;
;; Disabled while we test evil-mode.
;;
;; (use-package expand-region
;;   :ensure t
;;   :bind
;;   ("C-w" . er/expand-region))

;; web-mode --------------------------------------------------------------------
(use-package web-mode
  :ensure t
  :mode
  ("\\.tsx\\'" "\\.jsx\\'" "\\.js\\'" "\\.hbs\\'")
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-indent-style 2))

;; yaml-mode -------------------------------------------------------------------
(use-package yaml-mode
  :ensure t)

;; go-mode ---------------------------------------------------------------------
(use-package go-mode
  :ensure t)

;; lsp-mode --------------------------------------------------------------------
(use-package lsp-mode
  :ensure t
  :commands lsp
  :hook
  (go-mode . lsp)
  :config
  ;; This is needed as long as I'm working on dev of typescript-lsp.
  (setq lsp-log-io t)
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "/home/tato/src/typescript-lsp/cmd/typescript-lsp/typescript-lsp")
                    :major-modes '(web-mode)
                    :server-id 'typescript-lsp)))

;; lsp-ui ----------------------------------------------------------------------
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; lsp-ivy ---------------------------------------------------------------------
(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

;; eglot -----------------------------------------------------------------------
;;
;; Trying out lsp-mode, eglot wasn't working that well with go.
;;
;; (use-package eglot
;;   :ensure t
;;   :config
;;   (add-to-list 'eglot-server-programs '(web-mode . ("javascript-typescript-stdio"))))

;; projectile ------------------------------------------------------------------
(use-package projectile
  :ensure t
  :init
  ;; Use a different cache file for each computer
  (setq projectile-known-projects-file
        (expand-file-name (format "projectile-bookmarks-%s.eld" (system-name)) user-emacs-directory)
        projectile-cache-file
        (expand-file-name (format "projectile-%s.cache" (system-name)) user-emacs-directory))
  :config
  (projectile-mode t)

  ;; The asterisk is due to: https://github.com/bbatsov/projectile/issues/1250
  (add-to-list 'projectile-globally-ignored-directories "*node_modules")
  (add-to-list 'projectile-globally-ignored-directories "*bower_components")

  ;; Need an easier way to find file using Projectile, if available,
  ;; or using the standard file-file otherwise.
  ;; - https://emacs.stackexchange.com/a/12651/23627
  (defun find-file-with-projectile-or-fallback ()
    (interactive)
    (call-interactively
     (if (projectile-project-p)
         #'projectile-find-file
       #'find-file)))

  ;; Same thing but for buffers.
  (defun switch-to-buffer-with-projectile-or-fallback ()
    (interactive)
    (call-interactively
     (if (projectile-project-p)
         #'projectile-switch-to-buffer
       #'switch-to-buffer)))

  (defun test-project-and-rename-buffer ()
    (interactive)
    (projectile-test-project 'projectile-test-project-cmd)
    (with-current-buffer (compilation-find-buffer)
      (rename-buffer "*test*")))

  (setq projectile-completion-system 'ivy
        projectile-use-git-grep t)
        ;; projectile-switch-project-action 'neotree-projectile-action)

  :bind
  (:map evil-normal-state-map
        (",t" . find-file-with-projectile-or-fallback)
        (",e" . switch-to-buffer-with-projectile-or-fallback)
        (",rr" . projectile-run-project)
        (",rt" . test-project-and-rename-buffer))

  ;; ("C-t" . find-file-with-projectile-or-fallback)
  ;; ("C-l" . switch-to-buffer-with-projectile-or-fallback)
  ;; ("S-<f10>" . projectile-run-project)
  ;; ("C-S-<f10>" . test-project-and-rename-buffer)

  ;; (:map evil-insert-state-map
  ;;       ("C-t" . find-file-with-projectile-or-fallback)
  ;;       ("C-l" . switch-to-buffer-with-projectile-or-fallback)
  ;;       ("S-<f10>" . projectile-run-project)
  ;;       ("C-S-<f10>" . test-project-and-rename-buffer))

  :bind-keymap
  ("C-c p" . projectile-command-map))

;; ivy -------------------------------------------------------------------------
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode t))

;; counsel ---------------------------------------------------------------------
(use-package counsel
  :ensure t)

;; ivy-posframe-----------------------------------------------------------------
(use-package ivy-posframe
  :ensure t
  :after ivy
  :diminish ivy-posframe-mode
  :init
  (setq ivy-posframe-display-functions-alist
        '((t . ivy-posframe-display-at-frame-top-center)))
  :config
  (setq ivy-posframe-width 80
        ivy-posframe-parameters '((left-fringe . 2)
                                  (right-fringe . 2)))
  (ivy-posframe-mode t))

;; ivy-rich --------------------------------------------------------------------
;; (use-package ivy-rich
;;   :ensure t
;;   :after ivy
;;   :config
;;   (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
;;   (ivy-rich-mode t))

;; flycheck --------------------------------------------------------------------
(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (global-flycheck-mode t)
  ;; I use flycheck for tide, and tide recommends these settings
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  ;; To avoid https://github.com/flycheck/flycheck/issues/1472 on projects that
  ;; still use tslint
  (setq-default flycheck-disabled-checkers '(typescript-tslint)))

;; company ---------------------------------------------------------------------
(use-package company
  :ensure t
  :diminish company-mode
  :config
  (global-company-mode t)
  (setq company-idle-delay 0.25
        company-tooltip-align-annotations t))

;; typescript-mode -------------------------------------------------------------
(use-package typescript-mode
  :ensure t
  :config
  (setq typescript-indent-level 2))

;; tide ------------------------------------------------------------------------
(use-package tide
  :ensure t
  ;; Without this specific :commands when web-mode-hook was evaluated, it failed
  ;; with void-function.
  :commands tide-setup
  :hook
  (typescript-mode . tide-setup)
  (typescript-mode . tide-hl-identifier-mode)
  (web-mode . (lambda ()
                (when (string-equal "tsx" (file-name-extension buffer-file-name))
                  (tide-setup)
                  (tide-hl-identifier-mode))))
  :config
  (setq tide-completion-ignore-case t
        tide-hl-identifier-idle-time 0.0))

;; add-node-modules-path -------------------------------------------------------
;; This is needed for "prettier" to work, I don't have it globally installed.
(use-package add-node-modules-path
  :ensure t
  :hook (typescript-mode scss-mode web-mode))

;; prettier-js -----------------------------------------------------------------
(use-package prettier-js
  :ensure t
  :commands prettier-js
  ;; :hook
  ;; It was slightly slowing down tide, so I've disabled it for now.
  ;; (typescript-mode . prettier-js-mode)
  ;; (scss-mode . prettier-js-mode)
  ;; (web-mode . prettier-js-mode)
  :bind
  (:map evil-normal-state-map
        (",cf" . prettier-js)))

;; yasnippet -------------------------------------------------------------------
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (yas-global-mode t))

;; (use-package with-editor
;;   :load-path "with-editor")

;; (use-package transient
;;   :load-path "transient/lisp")

;; magit -----------------------------------------------------------------------
(use-package magit
  :ensure t
  :bind
  ("C-x g" . magit-status))

;; csharp-mode -----------------------------------------------------------------
(use-package csharp-mode
  :ensure t)

;; ansi-color ------------------------------------------------------------------
(use-package ansi-color
  :hook
  (compilation-filter . (lambda ()
                          (let ((inhibit-read-only t))
                            (ansi-color-apply-on-region (point-min) (point-max))))))

;; avy -------------------------------------------------------------------------
(use-package avy
  :ensure t)

;; ace-window ------------------------------------------------------------------
(use-package ace-window
  :ensure t
  :bind
  ("M-o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; exec-path-from-shell --------------------------------------------------------
(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

;; grep ------------------------------------------------------------------------
(use-package grep
  :hook
  ;; Taken from: https://emacs.stackexchange.com/a/46037
  (grep-mode . (lambda () (switch-to-buffer-other-window "*grep*")))
  :config
  ;; Without this the wrappers around rgrep will throw an error when used
  (grep-compute-defaults)
  (add-to-list 'grep-find-ignored-directories "node_modules"))

;; org -------------------------------------------------------------------------
(use-package org
  :config
  (defun counsel-org-file-jump ()
    "Jump to a file below the org files directory."
    (interactive)
    (counsel-file-jump "" "~/Dropbox/Notes"))

  ;; Taken from: https://emacs.stackexchange.com/a/14933
  (defun rgrep-org (&optional confirm)
    (interactive "P")
    (rgrep (grep-read-regexp)
           "*.org"
           "~/Dropbox/Notes"
           confirm))

  ;; Taken from: https://yiming.dev/blog/2018/03/02/my-org-refile-workflow/
  (defun open-org-buffer ()
    "Return the list of buffers with org files."
    (delq nil
          (mapcar (lambda (x)
                    (if (and (buffer-file-name x)
                             (string-match "\\.org$" (buffer-file-name x)))
                        (buffer-file-name x)))
                  (buffer-list))))

  (setq org-startup-with-inline-images t
        org-adapt-indentation nil
        org-agenda-files '("~/Dropbox/Notes/Private/tasks.org" "~/Dropbox/Notes/Private/goals.org")
        org-agenda-window-setup 'current-window
        org-todo-keywords '((sequence "TODO" "|" "DONE" "KILLED"))
        org-refile-targets '((open-org-buffer :maxlevel . 9))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm)
  
  (setq org-todo-keyword-faces
        '(("IN-PROGRESS" . (,class (:weight bold :box (:line-width 1 :color "#F4A939") :foreground "#F4A939" :background "#FFFFBE")))))
  
  (setq org-agenda-custom-commands
        '(("x" "Daily personal agenda"
           ((tags "+goal"
                  ((org-agenda-overriding-header "● 2020 Goals")
                   (org-agenda-prefix-format " ")))
            (tags "+project"
                  ((org-agenda-overriding-header "● On-going Projects")
                   (org-agenda-prefix-format " ")))
            (agenda ""
                    ((org-agenda-span 'day)
                     ;; (org-agenda-tag-filter-preset '("-work"))
                     (org-agenda-overriding-header "● Daily Goals")
                     (org-agenda-prefix-format " ")
                     ;; Do not carry-over undone scheduled tasks to the next day, otherwise they'll just
                     ;; keep growing. I want to go back and re-schedule them if I want to.
                     (org-scheduled-past-days 0)))))
          ("w" "Daily work agenda"
           ((agenda ""
                    ((org-agenda-start-day "-1d")
                     (org-agenda-span 2)
                     (org-agenda-tag-filter-preset '("+work"))
                     (org-agenda-overriding-header "● Daily Goals")
                     (org-agenda-prefix-format " % s")))
            ;; This is removing the filter-preset in the agenda, need to do that
            ;; filter differently before enabling this back.
            ;; (tags-todo "+work")
            ))
          ))

  (setq fill-column 100)

  :hook
  (focus-out . org-save-all-org-buffers)
  (org-mode . (lambda () (setq fill-column 100)))
  (org-mode . turn-on-auto-fill)

  :bind
  ("C-c a" . org-agenda)
  ("C-c d f" . counsel-org-file-jump)
  ("C-c d s" . rgrep-org)

  (:map evil-normal-state-map
        (",o>" . org-refile)))

;; ox --------------------------------------------------------------------------
(use-package ox
  :ensure nil
  :config
  (defun remove-private-links-filter (text backend info)
    "Removes any HTML link pointing to my private directory."
    (if (and
         (eq backend 'html)
         (string-match "file:///.*/Notes/Private/" text))
        (replace-regexp-in-string "<[^>]*>" "" text)
      text))

  (add-to-list 'org-export-filter-link-functions 'remove-private-links-filter))

;; olivetti --------------------------------------------------------------------
;; (use-package olivetti
;;   :ensure t
;;   :hook
;;   (org-mode . (lambda ()
;;                 (olivetti-mode)
;;                 (olivetti-set-width 100))))

;; org-bullets -----------------------------------------------------------------
(use-package org-bullets
  :ensure t
  :hook
  (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("●" "•" "•" "•" "•" "•")))

;; org-capture -----------------------------------------------------------------
(use-package org-capture
  :config
  (setq org-capture-templates
        '(
          ;; Tasks should have a :CREATED: timestamp because I might want to
          ;; expire them automatically after a certain time has passed.
          ("t" "Task" entry
           (file+datetree "~/Dropbox/Notes/Private/tasks.org")
           "* TODO %?
SCHEDULED: %t
:PROPERTIES:
:CREATED: %U
:END:
" :tree-type week)
          ("n" "Note" entry
           (file+datetree "~/Dropbox/Notes/Private/inbox.org")
           "* %U
%i%?" :tree-type week))))

;; org-expiry ------------------------------------------------------------------
;; Disabled for now. I'm manually adding the :CREATED: properties with the
;; capture template, which is enough for my workflow for now.
;;
;; If I re-activate, just remember that the (org-expiry-deinsinuate) didn't work
;; when I was using it before, the hooks were not removed.
;;
;; (use-package org-expiry
;;  :load-path "org-mode/contrib/lisp"
;;  :config
;;  (org-expiry-deinsinuate))

;; undo-tree -------------------------------------------------------------------
(use-package undo-tree
  :diminish undo-tree-mode)

;; eldoc-mode ------------------------------------------------------------------
(use-package eldoc
  :diminish eldoc-mode)

;; neotree ---------------------------------------------------------------------
(use-package neotree
  :ensure t
  :bind
  ("<f8>" . neotree-toggle))

;; htmlize ---------------------------------------------------------------------
(use-package htmlize
  :ensure t)

;; erc -------------------------------------------------------------------------
(use-package erc
  :config
  (setq erc-hide-list '("JOIN" "PART" "QUIT")))

(add-hook 'org-mode-hook
          (lambda ()
            (setq line-spacing .2)
            ;; (setq org-hide-emphasis-markers t)
            ;; (if (eq system-type 'windows-nt)
            ;;     (buffer-face-set '(:family "Zilla Slab" :background "#ffffff" :foreground "#222222" :height 120))
            ;;   (buffer-face-set '(:family "Zilla Slab" :background "#ffffff" :foreground "#222222" :height 140))))
            ))

;; ox-publish ------------------------------------------------------------------
(use-package ox-publish
  :config
  (setq org-publish-project-alist
        '(("org-notes"
           :base-directory "~/Dropbox/Notes/Public"
           :base-extension "org"
           :publishing-directory "~/src/www/_notes/"
           :recursive t
           :publishing-function org-html-publish-to-html
           :headline-levels 4
           :body-only t
           :with-toc nil
           :section-numbers nil
           :html-footnote-format " %s"
           :html-footnotes-section "
<div id=\"footnotes\">
  <h2 class=\"footnotes\">%s</h2>
  <div id=\"text-footnotes\">
    %s
  </div>
</div>"
           ))))

;; general ---------------------------------------------------------------------
(use-package general
  :ensure t
  :config

  (general-define-key
   :states '(normal insert)
   "C-t"   'find-file-with-projectile-or-fallback
   "C-e"   'switch-to-buffer-with-projectile-or-fallback
   "C-c c" 'org-capture)

  (general-define-key
   :states '(normal insert)
   :keymaps 'tide-mode-map
   "C-t"   'find-file-with-projectile-or-fallback
   "M-RET" 'typescript-fix-or-refactor-at-point
   "C-o"   'tide-jump-back)

  (general-define-key
   :states 'normal
   :keymaps 'tide-mode-map
   ",cr" 'tide-rename-symbol))

;; Global org-agenda/org-capture -----------------------------------------------
(defun egb-initialize-global-org-agenda ()
  "Initialize the frame with the global 'org-agenda'."
  (select-frame-set-input-focus (selected-frame))
  (delete-other-windows)
  (org-agenda nil " "))

(defun egb-initialize-global-org-agenda-with-org-capture ()
  "Initialize the frame with the global 'org-agenda' and prepare it to capture."
  (egb-initialize-global-org-agenda)
  (org-capture))

(defun egb-global-org-capture ()
  "Launch 'org-capture' on the global 'org-agenda' frame."
  (select-frame-by-name "*Global Org Agenda*")
  (org-capture))

(add-hook 'org-capture-mode-hook 'delete-other-windows)

;; Emacs on Windows ------------------------------------------------------------
(if (eq system-type 'windows-nt)
    (setq exec-path (append exec-path '("C:\\tools\\cmder\\vendor\\git-for-windows\\usr\\bin"))
          find-program "C:\\emacs\\bin\\find.exe"))

;; General
(defun find-dotfile-other-window ()
  "Edit .emacs in another window."
  (interactive)
  (find-file "~/.emacs"))

(global-set-key (kbd "C-c i") 'find-dotfile-other-window)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-f") 'isearch-forward)

(prefer-coding-system 'utf-8-unix)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)

(setq visible-bell t)

(setq make-backup-files nil)
(setq auto-save-default nil)
;; Disable lock files until https://github.com/facebook/create-react-app/issues/9056 is fixed
(setq create-lockfiles nil)

(setq explicit-shell-file-name "/bin/zsh")
(delete-selection-mode 1)

(setq-default truncate-lines 1)
(setq-default show-trailing-whitespace t)

(setq show-paren-delay 0)
(show-paren-mode 1)
(electric-pair-mode 1)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq fill-column 120)

(global-prettify-symbols-mode)
(global-hl-line-mode 1)

(defadvice split-window-right (after rebalance-windows activate)
  (balance-windows))

(defadvice split-window-below (after rebalance-windows activate)
  (balance-windows))


(global-set-key [S-M-left] 'shrink-window-horizontally)
(global-set-key [S-M-right] 'enlarge-window-horizontally)

(set-face-attribute 'default nil
                    :family "Fira Code"
                    :height (if (eq system-type 'windows-nt) 110 120)
                    :weight 'normal
                    :width 'normal)

(setq garbage-collection-messages t)

;; Scratchpad

;; ...

;; In case I want to have this in the future: this was set back when I wanted to
;; show the find box in the middle of the screen.
;;
;; (use-package counsel
;;   :defer t
;;   :init
;;   (ivy-mode t)
;;   :config
;;   (setq ivy-use-virtual-buffers t
;;         ivy-count-format "%d/%d "))
;;
;; (use-package ivy-posframe
;;   :defer t
;;   :init
;;   (setq ivy-display-function #'ivy-posframe-display-at-frame-center)
;;   (ivy-posframe-enable))
;;
;; (defun toggle-shortcuts ()
;;   "Toggle a window with Emacs shortcuts I'm trying to memorize"
;;   (interactive)
;;   (if w
;;       (progn
;;         (delete-window w)
;;         (setq w nil))
;;     (progn
;;       (setq w (split-window-below -10))
;;       (with-selected-window w
;;         (find-file "~/.emacs.shortcuts.md")))
;;     ))
;; (setq w nil)
;; (global-set-key (kbd "<f12>") 'toggle-shortcuts)
;;
;; ;; JS
;; (setq js-indent-level 2)
;;
;; ;; EmberJS
;; (setq ember-command "~/.node_modules/bin/ember")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "819ab08867ef1adcf10b594c2870c0074caf6a96d0b0d40124b730ff436a7496" "890a1a44aff08a726439b03c69ff210fe929f0eff846ccb85f78ee0e27c7b2ea" default))
 '(package-selected-packages
   '(color-theme-sanityinc-tomorrow general ivy-rich ox-rss fira-code-mode omnisharp neotree evil-commentary ox lsp-ui lsp-ivy lsp-mode auto-package-update evil evil-mode go-mode tide use-package))
 )
